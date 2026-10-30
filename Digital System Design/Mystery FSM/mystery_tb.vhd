Assignment 4: 

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY mystery_tb IS
END mystery_tb;
 
ARCHITECTURE behavior OF mystery_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT mystery
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         a : IN  std_logic;
         b : IN  std_logic;
         c : OUT  std_logic;
         d : OUT  std_logic;
         e : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal a : std_logic := '0';
   signal b : std_logic := '0';

      --Outputs
   signal c : std_logic;
   signal d : std_logic;
   signal e : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
      -- Instantiate the Unit Under Test (UUT)
   uut: mystery PORT MAP (
          clk => clk,
          rst => rst,
          a => a,
          b => b,
          c => c,
          d => d,
          e => e
        );

   -- Clock process definitions
   clk_process :process
   begin
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin          
      -- hold reset state for 100 ns.
      wait for 100 ns;  

      wait for clk_period*10;

      -- insert stimulus here 
            rst <= '1';
            wait for 100ns;
            rst <= '0';
            
            
            --After reset FSM should be in S2(c=1)
            assert (c = '0' and d = '0' and e = '1')
            report "ERROR - FSM not in S2 after reset" severity FAILURE;
            
            --input 00, s2 -> s2
            a <= '0';
            b <= '0';
            wait until rising_edge(clk);
            wait for 2ns;
            assert (c = '0' and d = '0' and e = '1')
            report "ERROR - output not correct" severity FAILURE;
      
            --input 01, s2 -> s2
            a <= '0';
            b <= '1';
            wait until rising_edge(clk);
            wait for 2ns;
            assert (c = '0' and d = '0' and e = '1')
            report "ERROR - output not correct" severity FAILURE;
      
            --input 10, s2 -> s3
            a <= '1';
            b <= '0';
            wait until rising_edge(clk);
            wait for 2ns;
            assert (c = '1' and d = '0' and e = '0')
            report "ERROR - hioutput not correct" severity FAILURE;
            
            --input 00, s3 -> s3
            a <= '0';
            b <= '0';
            wait until rising_edge(clk);
            wait for 2ns;
            assert (c = '1' and d = '0' and e = '0')
            report "ERROR - output not correct" severity FAILURE;
      
            --input 10, s3 -> s3
            a <= '1';
            b <= '0';
            wait until rising_edge(clk);
            wait for 2ns;
            assert (c = '1' and d = '0' and e = '0')
            report "ERROR - output not correct" severity FAILURE;
      
            --input 11, s3 -> s3
            a <= '1';
            b <= '1';
            wait until rising_edge(clk);
            wait for 2ns;
            assert (c = '1' and d = '0' and e = '0')
            report "ERROR - output not correct" severity FAILURE;
      
            --input 01, s3 -> s4
            a <= '0';
            b <= '1';
            wait until rising_edge(clk);
            wait for 2ns;
            assert (c = '0' and d = '1' and e = '1')
            report "ERROR - output not correct" severity FAILURE;
            
            --input 00, s4 -> s4
            a <= '0';
            b <= '0';
            wait until rising_edge(clk);
            wait for 2ns;
            assert (c = '0' and d = '1' and e = '1')
            report "ERROR - output not correct" severity FAILURE;
            
            --input 01, s4 -> s4
            a <= '0';
            b <= '1';
            wait until rising_edge(clk);
            wait for 2ns;
            assert (c = '0' and d = '1' and e = '1')
            report "ERROR - output not correct" severity FAILURE;
      
            --input 11, s4 -> s4
            a <= '1';
            b <= '1';
            wait until rising_edge(clk);
            wait for 2ns;
            assert (c = '0' and d = '1' and e = '1')
            report "ERROR - output not correct" severity FAILURE;

            --input 10, s4 -> s5
            a <= '1';
            b <= '0';
            wait until rising_edge(clk);
            wait for 2ns;
            assert (c = '1' and d = '0' and e = '1')
            report "ERROR - output not correct" severity FAILURE;
      
            --input 11, s5 -> s5
            a <= '1';
            b <= '1';
            wait until rising_edge(clk);
            wait for 2ns;
            assert (c = '1' and d = '0' and e = '1')
            report "ERROR - output not correct" severity FAILURE;
      
            --input 00, s5 -> s1
            a <= '0';
            b <= '0';
            wait until rising_edge(clk);
            wait for 2ns;
            assert (c = '1' and d = '1' and e = '0')
            report "ERROR - output not correct" severity FAILURE;
      
            --input 10, s1 -> s1
            a <= '1';
            b <= '0';
            wait until rising_edge(clk);
            wait for 2ns;
            assert (c = '1' and d = '1' and e = '0')
            report "ERROR - output not correct" severity FAILURE;
                  
            --input 11, s1 -> s1
            a <= '1';
            b <= '1';
            wait until rising_edge(clk);
            wait for 2ns;
            assert (c = '1' and d = '1' and e = '0')
            report "ERROR - output not correct" severity FAILURE;
            
            --input 01, s1 -> s3
            a <= '0';
            b <= '1';
            wait until rising_edge(clk);
            wait for 2ns;
            assert (c = '1' and d = '0' and e = '0')
            report "ERROR - output not correct" severity FAILURE;
            
            --input 01, s3 -> s4
            a <= '0';
            b <= '1';
            wait until rising_edge(clk);
            wait for 2ns;
            assert (c = '0' and d = '1' and e = '1')
            report "ERROR - output not correct" severity FAILURE;
      
            --input 10, s4 -> s5
            a <= '1';
            b <= '0';
            wait until rising_edge(clk);
            wait for 2ns;
            assert (c = '1' and d = '0' and e = '1')
            report "ERROR - output not correct" severity FAILURE;
      
            --input 00, s5 -> s1
            a <= '0';
            b <= '0';
            wait until rising_edge(clk);
            wait for 2ns;
            assert (c = '1' and d = '1' and e = '0')
            report "ERROR - output not correct" severity FAILURE;
      
            --input 00, s1 -> s4
            a <= '0';
            b <= '0';
            wait until rising_edge(clk);
            wait for 2ns;
            assert (c = '0' and d = '1' and e = '1')
            report "ERROR - output not correct" severity FAILURE;
      
            --input 10, s4 -> s5
            a <= '1';
            b <= '0';
            wait until rising_edge(clk);
            wait for 2ns;
            assert (c = '1' and d = '0' and e = '1')
            report "ERROR - output not correct" severity FAILURE;
      
            --input 00, s5 -> s4
            a <= '1';
            b <= '0';
            wait until rising_edge(clk);
            wait for 2ns;
            assert (c = '0' and d = '1' and e = '1')
            report "ERROR - output not correct" severity FAILURE;
      
            
            wait for 10ns;
            assert FALSE
            report "OK (not a failure)" severity FAILURE;
            
            
            
            
            
            

      wait;
   end process;

END;
