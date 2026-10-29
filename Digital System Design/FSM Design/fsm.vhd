ASSIGNMENT 2:
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fsm is
    Port ( clock : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           i : in  STD_LOGIC_VECTOR (1 downto 0);
           x : out  STD_LOGIC;
           y : out  STD_LOGIC;
           z : out  STD_LOGIC);
end fsm;

architecture Behavioral of fsm is
type stateval is (s1, s2, s3, s4, s5);
signal state, next_state: stateval;

begin
process (clock)
 begin
      if rising_edge(clock) then 
            if reset = '1' then
                  state <= s2;
            else 
                  state <= next_state;
            end if;
      end if;
end process;
      
process (state, i)
 begin
      case state is
            when s1 => 
                  if i = "00" then 
                        next_state <= s2;
                  elsif i = "01" then 
                        next_state <= s3;
                  else
                        next_state <= s1; 
                  end if;
            when s2 => 
                  if i = "00" then 
                        next_state <= s4;
                  elsif i = "01" then 
                        next_state <= s3;
                  else
                        next_state <= s2;
                  end if;
            when s3 => 
                  if i = "00" then 
                        next_state <= s4;
                  elsif i = "10" then 
                        next_state <= s2;
                  else
                        next_state <= s3;
                  end if;
            when s4 => 
                  if i = "00" then 
                        next_state <= s5;
                  else
                        next_state <= s4;
            end if;
            when s5 => 
                  if i = "10" then 
                        next_state <= s1;
                  elsif i = "11" then 
                        next_state <= s3;
                  else
                        next_state <= s5;
                  end if;
      end case;
end process;                  
                  

x <= '1' when (state = s3 or state = s4) else '0';                
y <= '1' when (state = s3 or state = s5) else '0';
z <= '1' when (state = s2 or state = s3) else '0';



end Behavioral;
