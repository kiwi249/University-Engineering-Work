#include "mbed.h"                                   //Include the Mbed libraries 
 
class Joystick {                                         //Begin Joystick class definition 

protected:                                              //Protected (Private) functions and data members inaccessible from outside the class
    DigitalIn up, down, left, right, fire;              //Declaration of DigitalIn object 
    bool status;                                        //Variable to recall the state of the LED 
 
public: 
    //constructor (special memeber function) ensuring data members are correctily initialised, creates parameters from digitalin class  
    //parameters (u) are stored in variables (up)
    //PinName = parameter type
    // ConstructorName(parameters) : data_member(parameter) {}
    //Take the parameters ‘u,d,l,r,f' and store them as the data members ‘up,down,left,right,fire'                                            
    Joystick(PinName u, PinName d, PinName l, PinName r, PinName f): up(u), down(d), left(l), right(r), fire(f) {} 
    /*bool uppressed(void){
    return up.read();
    }
    bool downpressed(void){
    return down.read();
    }
    bool leftpressed(void){
    return right.read();
    }
    bool rightpressed(void){
    return right.read();
    }
    bool firepressed(void){
    return fire.read();
    }*/

    bool uppressed(void){
    if (up.read() == 1) {
        return true;
    } else {
        return false;
        }
    }
    bool downpressed(void) {                        //member functions when button is pressed value is read 
    if (down.read() == 1) {
        return true;
    } else {
        return false;
        }
    }
    bool leftpressed(void){
    if (left.read() == 1) {
        return true;
    } else {
        return false;
        }
    }
    
    bool rightpressed(void){
    if (right.read() == 1) {
        return true;
    } else {
        return false;
        }
    }   
    bool firepressed(void){
    if (fire.read() == 1) {
        return true;
    } else {
        return false;
        }
    }                  

}; 

class LED                                           //Begin LED class definition 
{ 
 
protected:                                          //Protected (Private) data member declaration 
    DigitalOut outputSignal;                        //Declaration of DigitalOut object 
    bool status;                                    //Variable to recall the state of the LED 
 
public:                                             //Public declarations 
    LED(PinName pin) : outputSignal(pin){off();}    //Constructor - user provided pin name is assigned to the DigitalOut 
 
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


int main(){

    Joystick joy(A2, A3, A4, A5, D4);           //object created and assigned to corresponding joystick pin

    LED redLED (D5);                            //object created and assigned to correseponding LED pin
    LED blueLED(D8);                            //object created and assigned to correseponding LED pin
    LED greenLED (D9);                          //object created and assigned to correseponding LED pin

while (1) {                                     //infinite loop keeps code running 


    redLED.off();                               //initially turn LEDs off
    greenLED.off();
    blueLED.off();

    if (joy.uppressed()){                       //function in joystik class executed  
        redLED.on();
    }else if (joy.downpressed()){
        greenLED.on();
    } else if (joy.leftpressed()){
        blueLED.on();
    } else if (joy.rightpressed()){             //right joystick pressed red+green = yellow LED
        redLED.on();
        greenLED.on();
    } else if (joy.firepressed()) {             //fire joystick pressed red+green+blue = white LED blinks (wait(0.25) inbetween)
        redLED.on();                            
        greenLED.on();
        blueLED.on();
        wait(0.25);                             //frequency of 2Hz (0.25 = 0.5*(1/frequency))
        redLED.off();
        greenLED.off();
        blueLED.off();
        wait(0.25);
       
    }

}
}


