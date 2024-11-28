-- Datapath, fazendo a conexao entre cada componente

library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity datapath is
port (
-- Entradas de dados
SW: in std_logic_vector(9 downto 0);
CLOCK_50, CLK_1Hz: in std_logic;
-- Sinais de controle
R1, R2, E1, E2, E3, E4, E5: in std_logic;
-- Sinais de status
sw_erro, end_game, end_time, end_round: out std_logic;
-- Saidas de dados
HEX0, HEX1, HEX2, HEX3, HEX4, HEX5: out std_logic_vector(6 downto 0);
LEDR: out std_logic_vector(9 downto 0)
);
end datapath;

architecture arc of datapath is
--============================================================--
--                      COMPONENTS                            --
--============================================================--
-------------------DIVISOR DE FREQUENCIA------------------------

component Div_Freq is
	port (	    clk: in std_logic;
				reset: in std_logic;
				CLK_1Hz: out std_logic
			);
end component;

------------------------CONTADORES------------------------------

component counter_time is
port(Enable, Reset, CLOCK: in std_logic;
		load: in std_logic_vector(3 downto 0);
		end_time: out std_logic;
		tempo: out std_logic_vector(3 downto 0)
		);
end component;

component counter0to10 is
port(
    Enable, Reset, CLOCK: in std_logic;
	Round: out std_logic_vector(3 downto 0);
	end_round: out std_logic
	);
			
end component;

-------------------ELEMENTOS DE MEMORIA-------------------------

component reg4bits is 
port(
    CLK, RST, enable: in std_logic;
    D: in std_logic_vector(3 downto 0);
    Q: out std_logic_vector(3 downto 0)
    );
end component;

component reg8bits is 
port (
	CLK, RST, enable: in std_logic;
	D: in std_logic_vector(7 downto 0);
	Q: out std_logic_vector(7 downto 0)
);
end component;

component reg10bits is 
port(
	CLK, RST, enable: in std_logic;
	D: in std_logic_vector(9 downto 0);
	Q: out std_logic_vector(9 downto 0)
    );
end component;

component ROM is
port(
    address : in std_logic_vector(3 downto 0);
    data : out std_logic_vector(9 downto 0) 
    );
end component;

---------------------MULTIPLEXADORES----------------------------


component mux2pra1_4bits is
port(
    sel: in std_logic;
	x, y: in std_logic_vector(3 downto 0);
	saida: out std_logic_vector(3 downto 0)
    );
end component;

component mux2pra1_7bits is
port (sel: in std_logic;
		x, y: in std_logic_vector(6 downto 0);
		saida: out std_logic_vector(6 downto 0)
);
end component;

component mux2pra1_8bits is
port(
    sel: in std_logic;
	x, y: in std_logic_vector(7 downto 0);
	saida: out std_logic_vector(7 downto 0)
    );
end component;

component mux2pra1_10bits is
port(
    sel: in std_logic;
	x, y: in std_logic_vector(9 downto 0);
	saida: out std_logic_vector(9 downto 0)
    );
end component;

----------------------DECODIFICADOR-----------------------------

component decod7seg is
port(
    X: in std_logic_vector(3 downto 0);
    Y: out std_logic_vector(6 downto 0)
    );
end component;

-------------------COMPARADORES E SOMA--------------------------

component comp is
port (
    seq_user: in std_logic_vector(9 downto 0);
    seq_reg: in std_logic_vector(9 downto 0);
    seq_mask: out std_logic_vector(9 downto 0)
    );
end component;

component comp_igual4 is
port(
    soma: in std_logic_vector(3 downto 0);
    status: out std_logic
    );
end component;

component soma is
port(
    seq: in std_logic_vector(9 downto 0);
    soma_out: out std_logic_vector(3 downto 0)
    );
end component;

--============================================================--
--                      SIGNALS                               --
--============================================================--

signal selMux23, selMux45, end_game_interno, end_round_interno, clk_1, enableRegFinal: std_logic; --1 bit
signal Round, Level_time, Level_code, SaidaCountT, SomaDigitada, SomaSelDig, CounterTMux: std_logic_vector(3 downto 0); -- 4 bits
signal decMuxCode, decMuxRound, muxMux2, muxMux3, decMux4, Tempo, t, r, n, muxHEX5, muxHEX4, muxHEX3, muxHEX2, decHEX1, decHEX0: std_logic_vector(6 downto 0); -- 7 bits
signal SomaSelDig_estendido, SeqLevel, RegFinal, valorfin_vector, MuxSelDig: std_logic_vector(7 downto 0); -- 8 bits
signal N_unsigned: unsigned(3 downto 0);
signal SeqDigitada, ComparaSelDig, SelecionadaROM, EntradaLEDS: std_logic_vector(9 downto 0); -- 10 bits

begin

            ----------------------------------------
                ---- TODOS OS PORT MAP ----
            ----------------------------------------

------------------------DIVISOR FREQ------------------------------

DIV: Div_Freq port map (CLOCK_50, R2, clk_1); -- Para teste no emulador, comentar essa linha e usar o CLK_1Hz

------------------------CONTADORES------------------------------

COUNTERTIME: counter_time port map (E2, R1, clk_1, end_time, tempo);

COUNTER_0_TO_10: counter0to10 port map (E3, R2, clk_1, Round, end_round);

-------------------ELEMENTOS DE MEMORIA-------------------------

--REG4BITS: reg4bits port map (CLOCK_50, R2, );     			    -------------- ???
REG8BITS_1: reg8bits port map (CLOCK_50, R2, E1, SW(7 downto 0), );         ------------- FALTA A SAÍDA!!
REG8BITS_2: reg8bits port map (CLOCK_50, R2, (E5 or E4), MuxSelDig, valorfin_vector);
REG10BITS: reg10bits port map (CLOCK_50, R2, E2, SW(9 downto 0), ComparaSelDig); 
ROM0: ROM port map (Level_code, SelecionadaROM);

---------------------MULTIPLEXADORES----------------------------

-- 4bits

MUX_2X1_4BITS: mux2pra1_4bits port map(E2, Tempo, Level_time, CounterTMux); -- saída (CounterTMux) entra no decod7seg (para o display decodificador)

-- 7bits

MUX_2x1_T: mux2pra1_7bits port map ((E1 or E2), t, "1111111", muxHEX5); -- letra 't' p/ display, (HEX5)

MUX_2x1_: mux2pra1_7bits port map ((R1 xor R2), decMux4, "1111111", muxHEX4); -- (HEX4)

MUX_2x1_R: mux2pra1_7bits port map ((R1 xor R2), r, muxMux3, muxHEX3);-- (HEX3)
MUX_2x1_N: mux2pra1_7bits port map (E1, n, "1111111", muxMux3);  -- (HEX3)AUXILIAR

MUX_2x1_ROUND: mux2pra1_7bits port map ((R1 xor R2), decMuxRound, muxMux2, muxHEX2); -- (HEX2)
MUX_2x1_LEVELCODE: mux2pra1_7bits port map (E1, decMuxCode, "1111111", muxMux2);   -- (HEX2)AUXILIAR

-- 8bits

MUX_2x1_8BITS: mux2pra1_8bits port map (E5, "000" & end_game & Round, "1010" & SomaDigitada, MuxSelDig);

-- 10bits

MUX_2x1_10BITS: mux2pra1_10bits port map (E5, "0000000000", SelecionadaROM, EntradaLEDS);

-------------------COMPARADORES E SOMA--------------------------

COMP_SOMA: comp port map (SelecionadaROM, ComparaSelDig, SeqDigitada);

COMP_IGUAL_4_erro: comp_igual4 port map (SomaSelDig, sw_erro);
COMP_IGUAL_4_endgame: comp_igual4 port map (SomaDigitada, end_game);

SOMA_seq: soma port map (SeqDigitada, SomaDigitada);
SOMA_seldig: soma port map (ComparaSelDig, SomaSelDig);
        
---------------------DECODIFICADORES----------------------------

DEC7SEG_hex4: decod7seg port map (CounterTMux, decMux4);
DEC7SEG_hex2_1: decod7seg port map (Round, decMuxRound);
DEC7SEG_hex2_2: decod7seg port map (Level_code, decMuxCode);
DEC7SEG_hex1: decod7seg port map (, decHEX1);            ------------- FALTAM AS
DEC7SEG_hex0: decod7seg port map (, decHEX0);            ------------- ENTRADAS!!

---------------------ATRIBUICOES DIRETAS---------------------

-- a fazer pel@ alun@

end arc;
