Assignment 3: 
testbench: 

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY fsm_tb IS
END fsm_tb;
 
ARCHITECTURE behavior OF fsm_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT fsm
    PORT(
         clock : IN  std_logic;
         reset : IN  std_logic;
         i : IN  std_logic_vector(1 downto 0);
         x : OUT  std_logic;
         y : OUT  std_logic;
         z : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clock : std_logic := '0';
   signal reset : std_logic := '0';
   signal i : std_logic_vector(1 downto 0) := (others => '0');

      --Outputs
   signal x : std_logic;
   signal y : std_logic;
   signal z : std_logic;

   -- Clock period definitions
   constant clock_period : time := 10 ns;
 
BEGIN
 
      -- Instantiate the Unit Under Test (UUT)
   uut: fsm PORT MAP (
          clock => clock,
          reset => reset,
          i => i,
          x => x,
          y => y,
          z => z
        );

   -- Clock process definitions
   clock_process :process
   begin
            clock <= '0';
            wait for clock_period/2;
            clock <= '1';
            wait for clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin          
      -- hold reset state for 100 ns.
            reset <= '1';
      wait for 15 ns;
            reset <= '0';
            
            --wait until rising_edge(clock); --FSM loads reset state
            

      --wait for clock_period*10;

      -- insert stimulus here 
            --Apply input sequence and check outputs
            
            --After reset, FSM should be in S2 (z=1)
            assert (x = '0' and y = '0' and z = '1')
            report "ERROR - FSM not in S2 after reset" severity FAILURE;
            
            --input "00" -> S2 moves to S4
            i <= "00";
            wait until rising_edge(clock);
            wait for 2ns;
            assert (x = '1' and y = '0' and z = '0')
            report "ERROR - output not correct" severity FAILURE;
            
            --input 01, 10, 11 -> S4 moves to S4 
            i <= "01";
            wait until rising_edge(clock);
            wait for 2ns;
            assert (x = '1' and y = '0' and z = '0')
            report "ERROR - output not correct" severity FAILURE;
            i <= "10";
            wait until rising_edge(clock);
            wait for 2ns;
            assert (x = '1' and y = '0' and z = '0')
            report "ERROR - output not correct" severity FAILURE;
            i <= "11";
            wait until rising_edge(clock);
            wait for 2ns;
            assert (x = '1' and y = '0' and z = '0')
            report "ERROR - output not correct" severity FAILURE;
            
            --input "00" -> S4 moves to S5
            i <= "00";
            wait until rising_edge(clock);
            wait for 2ns;
            assert (x = '0' and y = '1' and z = '0')
            report "ERROR - output not correct" severity FAILURE;
            
            --input 00, 01, -> S5 moves to S5 
            i <= "00";
            wait until rising_edge(clock);
            wait for 2ns;
            assert (x = '0' and y = '1' and z = '0')
            report "ERROR - output not correct" severity FAILURE;
            i <= "01";
            wait until rising_edge(clock);
            wait for 2ns;
            assert (x = '0' and y = '1' and z = '0')
            report "ERROR - output not correct" severity FAILURE;
            
            --input "11" -> S5 moves to S3
            i <= "11";
            wait until rising_edge(clock);
            wait for 2ns;
            assert (x = '1' and y = '1' and z = '1')
            report "ERROR - output not correct" severity FAILURE;
            
            --input 01, 11 -> S3 moves to S3 
            i <= "01";
            wait until rising_edge(clock);
            wait for 2ns;
            assert (x = '1' and y = '1' and z = '1')
            report "ERROR - output not correct" severity FAILURE;
            i <= "11";
            wait until rising_edge(clock);
            wait for 2ns;
            assert (x = '1' and y = '1' and z = '1')
            report "ERROR - output not correct" severity FAILURE;
            
            --input "00" -> S3 moves to S4
            i <= "00";
            wait until rising_edge(clock);
            wait for 2ns;
            assert (x = '1' and y = '0' and z = '0')
            report "ERROR - output not correct" severity FAILURE;
            
            --input "00" -> S4 moves to S5
            i <= "00";
            wait until rising_edge(clock);
            wait for 2ns;
            assert (x = '0' and y = '1' and z = '0')
            report "ERROR - output not correct" severity FAILURE;
            
            --input "10" -> S5 moves to S1
            i <= "10";
            wait until rising_edge(clock);
            wait for 2ns;
            assert (x = '0' and y = '0' and z = '0')
            report "ERROR - output not correct" severity FAILURE;
            
            --input 10, 11 -> S1 moves to S1 
            i <= "10";
            wait until rising_edge(clock);
            wait for 2ns;
            assert (x = '0' and y = '0' and z = '0')
            report "ERROR - output not correct" severity FAILURE;
            i <= "11";
            wait until rising_edge(clock);
            wait for 2ns;
            assert (x = '0' and y = '0' and z = '0')
            report "ERROR - output not correct" severity FAILURE;
            
            --input "00" -> S1 moves to S2
            i <= "00";
            wait until rising_edge(clock);
            wait for 2ns;
            assert (x = '0' and y = '0' and z = '1')
            report "ERROR - output not correct" severity FAILURE;
            
            --asynchronous test 21ns 
            reset <= '1';
            wait for 15ns;
            assert(x = '0' and y = '0' and z = '1')
            report "ERROR - output not correct" severity FAILURE;
            reset <= '0';
            wait for 2ns;
            assert(x = '0' and y = '0' and z = '1')
            report "ERROR - output not correct" severity FAILURE;
            
            
            --input "00" -> S2 moves to S4
            i <= "00";
            wait until rising_edge(clock);
            wait for 2ns;
            assert (x = '1' and y = '0' and z = '0')
            report "ERROR - output not correct" severity FAILURE;
            
            --input "00" -> S4 moves to S5
            i <= "00";
            wait until rising_edge(clock);
            wait for 2ns;
            assert (x = '0' and y = '1' and z = '0')
            report "ERROR - output not correct" severity FAILURE;
            
            --input "10" -> S5 moves to S1
            i <= "10";
            wait until rising_edge(clock);
            wait for 2ns;
            assert (x = '0' and y = '0' and z = '0')
            report "ERROR - output not correct" severity FAILURE;
            
            --input "01" -> S1 moves to S3
            i <= "01";
            wait until rising_edge(clock);
            wait for 2ns;
            assert (x = '1' and y = '1' and z = '1')
            report "ERROR - output not correct" severity FAILURE;
            
            --input "10" -> S3 moves to S2
            i <= "10";
            wait until rising_edge(clock);
            wait for 2ns;
            assert (x = '0' and y = '0' and z = '1')
            report "ERROR - output not correct" severity FAILURE;
            
            --input 10, 11 -> S2 moves to S2
            i <= "10";
            wait until rising_edge(clock);
            wait for 2ns;
            assert (x = '0' and y = '0' and z = '1')
            report "ERROR - output not correct" severity FAILURE;
            i <= "11";
            wait until rising_edge(clock);
            wait for 2ns;
            assert (x = '0' and y = '0' and z = '1')
            report "ERROR - output not correct" severity FAILURE;
            
            --input 01 -> S2 moves to S3
            i <= "01";
            wait until rising_edge(clock);
            wait for 2ns;
            assert (x = '1' and y = '1' and z = '1')
            report "ERROR - output not correct" severity FAILURE;
            
            wait for 2ns;
            assert FALSE
            report "OK (not a failure)" severity FAILURE;
            

      wait;
   end process;

END;
