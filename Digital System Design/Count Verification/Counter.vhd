ASSIGNMENT 1:

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity counter is
    port ( preset : in std_logic;
           clk    : in std_logic;
           up     : in std_logic;
           count  : out std_logic_vector (7 downto 0));
end counter;

architecture behavioural of counter is
signal q : unsigned (7 downto 0);
begin

  counter: process (preset, clk)
  begin
    if preset = '1' then
        q <= (others => '1');
    elsif rising_edge (clk) then
        if up = '1' then
          q <= q + 1;
        else
          q <= q - 1;
           end if;
    end if; 
  end process;

  count <= std_logic_vector (q);

end behavioural;
