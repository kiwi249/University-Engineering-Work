library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity circuit is
    Port ( a : in  STD_LOGIC;
           b : in  STD_LOGIC;
           c : in  STD_LOGIC;
           d : in  STD_LOGIC;
           x : out  STD_LOGIC;
           y : out  STD_LOGIC);
end circuit;

architecture Behavioral of circuit is
signal p, q, r, s, t: std_logic;
begin
with r select
t <= p when '0',
            a when '1',
            'X' when others;
                        
r <= not b;
p <= a xor r;


q <= a or c or d;
s <= not q; 

x <= s or t;
y <= s;



end Behavioral;
