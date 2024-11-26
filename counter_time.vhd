library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_time is
    port(Enable, Reset, CLOCK: in std_logic;
        load     : in  std_logic_vector(3 downto 0); -- Valor inicial da contagem
        end_time : out std_logic;                    -- Sinal ativo quando o tempo acaba
        tempo    : out std_logic_vector(3 downto 0)  -- Valor atual do contador
        );
end counter_time;

architecture arqtime of counter_time is
    signal count : unsigned(3 downto 0) := (others => '0'); -- Contador interno (unsigned para operações aritméticas)
    signal load_value : unsigned(3 downto 0);               -- Valor convertido de load
begin

    -- controla o contador
    process(CLOCK, Reset)
    begin
        if Reset = '1' then
            count <= "0000"; -- Reseta contador p/ 0
        elsif rising_edge(CLOCK) then
            if Enable = '1' then
                if count = 0 then
                    count <= 0; -- Mantém 0 
                else
                    count <= count - 1; -- Decresce o contador
                end if;
            end if;
        end if;
    end process;

    -- Carrega valor inicial load no contador
    load_value <= unsigned(load); -- Converte load p/ unsigned
    process(Reset, load)
    begin
        if Reset = '1' then
            count <= load_value; -- Carrega o valor inicial no reset
        end if;
    end process;

    
    end_time <= '1' when count = 0 else '0';

    tempo <= std_logic_vector(count); -- Converte count p/ std_logic_vector

end arqtime;
