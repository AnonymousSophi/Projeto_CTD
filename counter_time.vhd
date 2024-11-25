library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all; 
use ieee.std_logic_arith.all;

entity counter_time is
port(Enable, Reset, CLOCK: in std_logic;
	load: in std_logic_vector(3 downto 0);
	end_time: out std_logic;
	tempo: out std_logic_vector(3 downto 0)
	);
end counter_time;

architecture arqtime of counter_time is
    
    signal count: std_logic_vector(3 downto 0);
    
begin
    
    process(CLOCK, Reset, Enable, load)
    
    begin
    
        if (Reset = '1') then
        count <= "1010";
        elsif (CLOCK'event and CLOCK='1') then
            if (Enable='1') then
	        	count <= count + load;
            end if;
        end if;
    end process;
	end_time <= '1' when (count < "0001") else '0';

    tempo <= count;

end arqtime;
