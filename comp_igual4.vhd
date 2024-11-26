library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity comp_igual4 is
    Port (soma   : in  std_logic_vector(3 downto 0); -- Entrada de 4 bits
          status : out std_logic                     -- Saída, 1 quando soma = 4
          );
end comp_igual4;

architecture bhav of comp_igual4 is
begin
    process(soma)
    begin
        if soma = "0100" then
            status <= '1'; -- Ativa status quando soma = 4
        else
            status <= '0'; -- Status desativado quando diferente de 4
        end if;
    end process;
end bhav;
