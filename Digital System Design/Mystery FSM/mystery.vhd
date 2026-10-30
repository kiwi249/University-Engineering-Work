Assignment 4: 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mystery is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           a : in  STD_LOGIC;
           b : in  STD_LOGIC;
           c : out  STD_LOGIC;
           d : out  STD_LOGIC;
           e : out  STD_LOGIC);
end mystery;

architecture Behavioral of mystery is

      type stateval is (s1, s2, s3, s4, s5);
      signal state, next_state: stateval;

begin

      process (clk)
            begin 
                  if rising_edge(clk) then 
                        if rst = '1' then 
                              state <= s2;
                        else 
                              state <= next_state;
                        end if;
                  end if;
      end process;
      
      process (state, a, b)
            begin
                  case state is
                        when s1 =>
                              if a = '0' and b = '0' then
                                    next_state <= s4;
                              elsif a = '0' and b = '1' then
                                    next_state <= s3;
                              else next_state <= s1;
                              end if;
                        when s2 =>
                              if a = '1' and b = '0' then
                                    next_state <= s3;
                              elsif a = '1' and b = '1' then
                                    next_state <= s1;
                              else next_state <= s2;
                              end if;
                        when s3 =>
                              if a = '0' and b = '1' then
                                    next_state <= s4;
                              else next_state <= s3;
                              end if;
                        when s4 =>
                              if a = '1' and b = '0' then
                                    next_state <= s5;
                              else next_state <= s4;
                              end if;
                        when s5 =>
                              if a = '0' and b = '0' then
                                    next_state <= s1;
                              elsif a = '0' and b = '1' then
                                    next_state <= s2;
                              elsif a = '1' and b = '0' then
                                    next_state <= s4;
                              else next_state <= s5;
                              end if;
                              
                  end case;
      end process;
      
      c <= '1' when (state = s1 or state = s3 or state = s5) else '0';
      d <= '1' when (state = s1 or state = s4) else '0';
      e <= '1' when (state = s2 or state = s4 or state = s5) else '0';
      

end Behavioral;
