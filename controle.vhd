--Bloco de controle, tem a descrição de funcionamento da máquina de estados. Garante que tudo funciona como deve, saídas e transições de um estado para outro.

library ieee;
use ieee.std_logic_1164.all;

entity controle is
port
(
BTN1, BTN0, clock_50: in std_logic;
sw_erro, end_game, end_time, end_round: in std_logic;
R1, R2, E1, E2, E3, E4, E5: out std_logic
);
end entity;
--Bloco de controle, tem a descrição de funcionamento da máquina de estados. Garante que tudo funciona como deve, saídas e transições de um estado para outro.

library ieee;
use ieee.std_logic_1164.all;

entity controle is
port(BTN1, BTN0, clock_50: in std_logic;
    sw_erro, end_game, end_time, end_round: in std_logic;
    R1, R2, E1, E2, E3, E4, E5: out std_logic
    );
end entity;

architecture arc of controle is
	type State is (Start, Setup, Play, Count_Round, Check, Waits, Result); --Aqui temos os estados
	signal EA, PE: State := Start; 						-- PE: proximo estado, EA: estado atual 

begin
-- FSM usando dois process a ser feito pel@ alun@

    process(clock_50, BTN0)
    begin
   
        if BTN0 = '1' then
            EA <= Init;
        elsif (clock_50'event and clock_50 = '1') then
            EA <= PE;
        end if;
   
    end process;
    
    process(EA, BTN1, sw_erro, end_game, end_TIME, end_round)
    begin
   
        case EA is
            when Init => 
            if BTN1 = '1' then
                PE <= Setup; -- Vai para o estado Setup quando enter for pressionado
            else
                PE <= Init;
            end if;
                R1 <= '1';
                R2 <= '0';
                E1 <= '0';
                E2 <= '0';
                E3 <= '0';
                E4 <= '0';
                E5 <= '0';
           
            when Setup =>
                if enter = '1' then
                    PE <= Play; -- Vai para o estado Play quando enter for pressionado
                else
                    PE <= Setup; -- Senão, fica no Setup
                end if;
                R1 <= '0';
                R2 <= '1';
                E1 <= '0';
                E2 <= '0';
                E3 <= '0';
                E4 <= '0';
                E5 <= '0';
                           
            when Play=>
                if enter = '1' then
                    PE <= Count_round; -- Vai para o estado Select quando enter for pressionado
                else
                    PE <= Play; -- Senão, fica no Setup
                end if;
                R1 <= '0';
                R2 <= '1';
                E1 <= '0';
                E2 <= '0';
                E3 <= '0';
                E4 <= '0';
                E5 <= '0';



end architecture;
architecture arc of controle is
	type State is (Start, Setup, Play, Count_Round, Check, Waits, Result); --Aqui temos os estados
	signal EA, PE: State := Start; 						-- PE: proximo estado, EA: estado atual 

begin


-- FSM usando dois process a ser feito pel@ alun@

end architecture;
