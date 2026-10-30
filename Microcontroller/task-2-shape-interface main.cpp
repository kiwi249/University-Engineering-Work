#include "mbed.h"
#include "C12832.h"
C12832 lcd(D11, D13, D12, D7, D10);


//------have to use global variables unfortunately-----------------------------------------------
// Variables shared between main loop and ISRs
static int center_X = 64; 
static int center_Y = 16;
static int newX = 64; 
static int newY = 16;
static int oldX = 64; 
static int oldY = 16;
static bool cursor_first_run = true;
// ------------------------------------------------------------

//------------------Classes---------------------------------------------------------------------
//Begin updated potentiometer class definition
class Potentiometer                                                     
{
//Private data member declaration
private:                                                                
    //Declaration of AnalogIn object
    AnalogIn inputSignal;                                               
    //Float variable to speficy the value of VDD (3.3 V for the Nucleo-64)
    float VDD, currentSampleNorm, currentSampleVolts;

// Public declarations
public:                                                                 
    //Constructor - user provided pin name assigned to AnalogIn...
    //VDD is also provided to determine maximum measurable voltage
    Potentiometer(PinName pin, float v) : inputSignal(pin), VDD(v) {}   
                                                                        
    //Public member function to measure the amplitude in volts
    float amplitudeVolts(void)                                          
    {
        //Scales the 0.0-1.0 value by VDD to read the input in volts
        return (inputSignal.read()*VDD);                                
    }

    //Public member function to measure the normalised amplitude
    float amplitudeNorm(void)                                           
    {
        //Returns the ADC value normalised to range 0.0 - 1.0
        return inputSignal.read();                                      
    }

    //Public member function to read a sample and store the value as data members
    void sample(void)                                                   
    {
        //Read a sample from the ADC and store normalised representation [0..1]
        currentSampleNorm = inputSignal.read();                         
        //Convert this to a voltage and store that as a data member too.
        currentSampleVolts = currentSampleNorm*VDD;                     
    }

    //Public member function to return the most recent normalised sample [0..1]
    const float getCurrentSampleNorm(void)                              
    {
        //Return the most recent normalised sample
        return currentSampleNorm;                                       
    }

    //Public member function to return the most recent sampled voltage [0.. 3.3 V]
    const float getCurrentSampleVolts(void)                             
    {
        //Return the most recent sampled voltage
        return currentSampleVolts;                                      
    }

};

/*class SamplingPotentiometer : public Potentiometer {

    private:
    Ticker sample; 
    float samplingFrequency, samplingPeriod;
    
    public:
    SamplingPotentiometer(PinName p, float v, float fs): Potentiometer(p, v), samplingFrequency(fs) {}
};*/

class SamplingPotentiometer : public Potentiometer {

    private:
    Ticker sample; 
    float samplingFrequency, samplingPeriod;
    
    public:
    //have to use casting to point to the ticker?
    //add samplingperiod to the initaliser 
    SamplingPotentiometer(PinName p, float v, float fs): 
        Potentiometer(p, v), 
        samplingFrequency(fs),
        //calculate the period in seconds
        samplingPeriod(1.0f/fs)

        {
        //pointer
        sample.attach(callback(this, &Potentiometer::sample), samplingPeriod);
    };
};

class LED                                           //Begin LED class definition 
{ 
 
protected:                                          //Protected (Private) data member declaration 
    DigitalOut outputSignal;                        //Declaration of DigitalOut object 
    bool status;                                    //Variable to recall the state of the LED 
 
public:                                             //Public declarations 
    LED(PinName pin) : outputSignal(pin) 
    { 
        off();   //Constructor - user provides the pin name, which is assigned to the DigitalOut 
    } 
 
    void on(void)                                   //Public member function for turning the LED on 
    { 
        outputSignal = 0;                           //Set output to 0 (LED is active low) 
        status = true;                              //Set the status variable to show the LED is on 
    } 
 
    void off(void)                                  //Public member function for turning the LED off 
    { 
        outputSignal = 1;                           //Set output to 1 (LED is active low) 
        status = false;                             //Set the status variable to show the LED is off 
    } 
 
    void toggle(void)                               //Public member function for toggling the LED 
    { 
        if (status)                                 //Check if the LED is currently on 
            off();                                  //Turn off if so 
        else                                        //Otherwise... 
            on();                                   //Turn the LED on 
    } 
 
    bool getStatus(void)                            //Public member function for returning the status of the LED 
    { 
        return status;                              //Returns whether the LED is currently on or off 
    } 
}; 


class Shape {

    private:

    enum Shapetype { circle, square, rectangle} type; // 0 = circle, 1 = square, 2 = rectangle
    float x, y; //position
    float dim1, dim2; //dimentions
                        // circle: radius, 0
                        //square: side, side
                        // rectangle: width, height

    public:

    //constructor for circle
    Shape(float centreX, float centreY, float radius): type(circle), x(centreX), y(centreY), dim1(radius), dim2(0) {}
    
    //constructor for square
    Shape(float centreX, float centreY, int length): type(square), x(centreX), y(centreY), dim1(length) {}

    //constructor for rectangle
    Shape(float centreX, float centreY, float length, float height): type(rectangle), x(centreX), y(centreY), dim1(length), dim2(height) {}
   
   //member functions for all shapes

   float area() {
       switch(type){
           case circle:
                //might add an iff statement
                //if calculate is pressed then return value
                return 3.14159 * dim1 * dim1;
            case square:
                return dim1*dim1;
            case rectangle:
                return dim1 * dim2;
            default:
                return 0;
       }
   }
   float circumference() {
       switch(type){
           case circle:
                return 3.14159 * dim1;
            case square:
                return (2*dim1) + (2*dim2);
            case rectangle:
                return (2*dim1) + (2*dim2);
            default:
                return 0;
       }
   }
   /*float aspectRatio() {
       switch(type){
           case CIRCLE:
                return 3.14159 * dim1 * dim1;
            case SQUARE:
                return dim1*dim2;
            case RECTANGLE:
                return dim1 * dim2;
            default:
                return 0;
       }
   }*/
    
    };
 //-------------------------------------------------------------------------------------


//Definition of the enum that refers to the states of the program
typedef enum {
    initialisation,
    start_point, 
    shape_menu, 
    circle_workflow,
    draw_circle,
    square_workflow, 
    rectangle_workflow,
    option_menu
    } ProgramState;     
 //Initialisation of the state machine, which is stored as an enum
ProgramState state = initialisation;   
 
 
 //----------Interrupts-------------------------------------------------------------

//ISR executed each time up is pressed. Used to advance program state.
void upISR()           
{ 
    //lcd.cls(); //might remove

//This statement determines which state to advance to, depending on the current program state. 
    switch (state) {              
 
        case (initialisation) : 
            state = initialisation; 
            break; 
 
        case (start_point) : 
            state = start_point; 
            break;

        case (shape_menu) :
            //lcd.cls();
            state = circle_workflow; 
            break; 
        case (circle_workflow) :
            state = circle_workflow; 
            break; 
            default: 
            state = initialisation;
    }
}

//ISR executed each time down is pressed. Used to advance program state
void downISR()          
{ 
 
if (state == shape_menu){
    state = square_workflow;
    }
}


void fireISR()          //ISR executed each time fire is pressed. Used to advance program state. 
{ 
 //lcd.cls(); //might remove
switch (state) {        //This statement determines which state to advance to, depending on the current program state.       
 
        case (initialisation) : 
            state = start_point; 
            break; 
 
        case (start_point) :
            //lcd.cls();
            
            center_X = newX;
            center_Y = newY;
            state = shape_menu; 
            // Reset the flag so shape_menu clears the screen once:
            cursor_first_run = true; // Reuse the flag for this purpose
            break;

        case (shape_menu) : 
            
            state = rectangle_workflow; 
            break; 
 
        case (circle_workflow) : 
            
            //draw circle/define radius of circle 
            
            //fire button pressed in the circle_rowkflow
            //will go to options menu
            state = draw_circle; 
            break; 
         
        case (draw_circle) : 


            //draw square

            //fire button pressed in this state 
            //will go to options menu
            state = option_menu; 
            break; 
 
        default: 
            state = initialisation;     //Specifies a default state in case of error 
 } 
 
} 
 
void resetpressedISR()
{
    
}

//static int center_X = 64; // Will store the final X chosen in start_point
//static int center_Y = 16;

//Begin main function - program starts executing here.
int main()                                    
{ 
    //joystick initalisation
    //Declare interruptIn object for centre pin
    InterruptIn centre(D4);  
    //Declare interruptIn object for centre pin                 
    InterruptIn up(A2);      
    //Declare interruptIn object for centre pin
    InterruptIn down(A3);                   
    
    //led initalisation
    LED redLED(D5);                          //Declare LED object for red LED 
    LED blueLED(D8);                         //Declare LED object for blue LED 
    LED greenLED(D9);                        //Declare LED object for green LED 
 
    //interupts
    //Set initial state of state machine: initialisation
    state = initialisation;                   
    centre.rise(&fireISR);
    up.rise(&upISR);
    down.rise(&downISR);

    //left potentiometer (x-axis) on pin A0, 3.3V, 100Hz sampling
    SamplingPotentiometer left(A0, 3.3, 100.0f);
    //left potentiometer (x-axis) on pin A0, 3.3V, 100Hz sampling
    SamplingPotentiometer right(A1, 3.3, 100.0f);

    //initialise old position for tracking
    //static int oldX = 64, oldY = 16;
    //lcd.cls();

    //static bool cursor_first_run = true; // NEW FLAG
//static int newX = 64, newY = 16; // Use these to store latest pot reading
    
    //Main while() loop
    while(true) {        
        
        // read potentiometer values (sampled by ticker) (0 to 1)
        float leftValue = left.getCurrentSampleNorm();
        float rightValue = right.getCurrentSampleNorm();
                                

        //use static variable to track previous position - might delete
        //already use it within main function
        //static int oldX = 64, oldY = 16;
// NEW LOGIC: Always update newX/newY from pot reading
    newX = (int)(leftValue * 127.0f);
    newY = (int)(rightValue * 31.0f);
        
        //Main switch statement for state machine
        switch (state) {                      
 
            case(initialisation) :
                //clear screeen
                //lcd.cls();
                lcd.cls();

    // RESET ALL CURSOR TRACKING VARIABLES TO CENTER
    // (This is the critical sync missing before the first draw)
    oldX = 64; 
    oldY = 16;
    newX = 64; // Ensures the first pot reading is used only after the reset
    newY = 16;
    cursor_first_run = true; // Ensure start_point runs the center logic
                
                // map new cursor postions 
                state = start_point;

            //Initialisation state 
            case (start_point) :          
                
                //set LED to Red
                redLED.on();
                greenLED.off();
                blueLED.off();

                //initialise new position

                //int newX, newY;
                if (cursor_first_run) {
                    newX = 64; 
                    newY = 16;
                    cursor_first_run = false;
                }else{
                newX = (int)(leftValue * 127.0f);
                newY = (int)(rightValue * 31.0f);}

                //deletes old curosr by drawing it with background colour: 0
                lcd.pixel(oldX, oldY, 0);

                //new cursor
                lcd.pixel(newX, newY, 1);

                //update old position for next iteration
                //deletes past positions (prevents drawing)
                oldX = newX;
                oldY = newY;
                lcd.copy_to_lcd();

                //clears and moves on
                //state = shape_menu;

                //Exit switch statement
                break;
                /*centre.rise(&fireISR); 
                state = red; 
                break;                        */
 
            case (shape_menu) :                     //Sets LED red 
 
                //clear screen
                //lcd.cls();

                //white LED
                redLED.on(); 
                greenLED.on(); 
                blueLED.on(); 

                if (cursor_first_run) {
        // 1. Clear screen ONCE
        lcd.cls();
        
        // 2. Draw all fixed menu icons and shadow ONCE
        // ... (Your menu drawing code here) ...

        

                //rectangle boarder
                //from (10,5) to (110,25)
                lcd.rect(10, 5, 110, 25, 1);
                //shadow fill
                //right rectangle
                lcd.fillrect(110, 10, 115, 29, 1);
                //bottom rectangle
                lcd.fillrect(20, 25, 115, 29, 1);

                //circle
                lcd.circle(18, 15, 5, 1);  // Circle at (20,15) radius 5
                //up arrow
                //vertical line
                lcd.line(33, 10, 33, 20, 1);
                //left diagonal
                lcd.line(33, 10, 26, 15, 1);
                //right diagonal
                lcd.line(33, 10, 40, 15, 1);
                
                //square
                lcd.rect(43, 10, 53, 20, 1);
                //down arrow
                //vertical line
                lcd.line(63, 10, 63, 20, 1);
                //left diagonal
                lcd.line(63, 20, 56, 15, 1);
                //right diagonal
                lcd.line(63, 20, 70, 15, 1);

                //rectangle 
                lcd.rect(73, 10, 90, 20, 1);
                //cross
                //left diagonal
                lcd.line(93, 10, 107, 20, 1);
                //right diagonal
                lcd.line(93, 20, 107, 10, 1);

                // 3. Disable flag
        cursor_first_run = false;
    }               

                 //Exit switch statement
                 break;                       
      
            /*case (circle_workflow) :                   
 
                lcd.cls();
                //Sets LED blue
                redLED.off(); 
                greenLED.off(); 
                blueLED.on(); */

    
    
    // 1. One-time Entry Setup
    if (cursor_first_run) {
        lcd.cls();
        // Sets LED blue
        redLED.off(); 
        greenLED.off(); 
        blueLED.on(); 
        
        // Reset tracking variables
        //oldX = 64;
        oldY = center_Y;
        cursor_first_run = false;
    }
    
    // 2. Read only vertical movement for radius
    int newY = (int)(rightValue * 31.0f); 

    // Calculate Radius: distance between current Y and center Y
    int currentRadius = newY - oldY; 


                state = draw_circle;                       //Exit switch statement 
 
            case (draw_circle):                    //Sets LED green 
                
                if (cursor_first_run) {
        lcd.cls();
        // Sets LED blue
        redLED.off(); 
        greenLED.off(); 
        blueLED.on(); 
        
        // Reset tracking variables
        oldX = 64;
        oldY = 16;
        cursor_first_run = false;
    } 
lcd.circle(oldX, oldY, currentRadius, 1); 
    
    
    lcd.copy_to_lcd();


                break;*/                       //Exit switch statement 
 
            case (rectangle_workflow):                     //Sets LED cyan 
                redLED.off(); 
                greenLED.on(); 
                blueLED.on(); 
                break;                       //Exit switch statement 
 
            /*case (blue):                     //Sets LED blue 
                redLED.off(); 
                greenLED.off(); 
                blueLED.on(); 
                break;                       //Exit switch statement 
 
            case (purple):                   //Sets LED purple 
                redLED.on(); 
                greenLED.off(); 
                blueLED.on();                
                break;                       //Exit switch statement 
 
            case (white):                    //Sets LED white 
                redLED.on(); 
                greenLED.on(); 
                blueLED.on();    
                break;                       //Exit switch statement 
 
            case (off):                      //Sets LED off 
                redLED.off(); 
                greenLED.off(); 
                blueLED.off();    
                break; */                      //Exit switch statement 
 
            default:                         //Default state in case of error. Returns to initial state i.e. resets program. 
                state = initialisation; 
        } 
 
    } 


    /*while (1) {
        if (initialisation){
            lcd.locate(0,0);
            lcd.printf(".");
        }
    }*/

} 


