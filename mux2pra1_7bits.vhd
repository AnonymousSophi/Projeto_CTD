library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity mux2pra1_7bits is port (
    S     : in  std_logic;
    L0, L1: in  std_logic_vector(6 downto 0);
    D     : out std_logic_vector(6 downto 0));
end mux2pra1_7bits;
        
architecture arqdtp of mux2pra1_7bits is
    begin
    
     D <=  L0   when s <= '0' else
		   L1;
		   
end arqdtp;
