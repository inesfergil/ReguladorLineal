----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.05.2025 11:17:51
-- Design Name: 
-- Module Name: binBCD - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bin2bcd is
  Port ( clk : in  std_logic;
         reset : in  std_logic;
         inicio : in  std_logic;
         num_bin : in  std_logic_vector (23 downto 0);
         segmentos 	: out std_logic_vector(6 downto 0);
         selector 	: out std_logic_vector(3 downto 0);
         ovf_1ms : in std_logic
         );
         
end bin2bcd;

architecture Behavioral of bin2bcd is
  signal bcd : std_logic_vector(15 downto 0);
  signal temp_bin : unsigned(12 downto 0);
  signal und :   std_logic_vector (3 downto 0);
  signal dec :   std_logic_vector (3 downto 0);
  signal cen :   std_logic_vector (3 downto 0);
  signal mil :   std_logic_vector (3 downto 0);
  signal num_bin2 :  std_logic_vector (9 downto 0):= (others => '0');
  --multiplexor--
  signal decodificador : unsigned(3 downto 0);
  
  ------------SEÑALES CONTADOR--------------  
  signal contador_uns 		: unsigned(3 downto 0);
  constant contador_uns_MAX 	: unsigned :="0101";
  
begin

    process(clk, reset)
        variable bcd_reg : std_logic_vector(15 downto 0);
        variable bin : unsigned(9 downto 0);
        variable i : integer;
    begin
        if reset = '1' then
            bcd <= (others => '0');
        elsif rising_edge(clk) then
            if inicio = '1' then
                num_bin2 <= num_bin(23 downto 14);
                bin := unsigned(num_bin2);
                bcd_reg := (others => '0');

                for i in 0 to 9 loop
                    -- Corrección
                    if bcd_reg(3 downto 0) > "0100" then
                        bcd_reg(3 downto 0) := std_logic_vector(unsigned(bcd_reg(3 downto 0)) + 3);
                    end if;
                    if bcd_reg(7 downto 4) > "0100" then
                        bcd_reg(7 downto 4) := std_logic_vector(unsigned(bcd_reg(7 downto 4)) + 3);
                    end if;
                    if bcd_reg(11 downto 8) > "0100" then
                        bcd_reg(11 downto 8) := std_logic_vector(unsigned(bcd_reg(11 downto 8)) + 3);
                    end if;
                    if bcd_reg(15 downto 12) > "0100" then
                        bcd_reg(15 downto 12) := std_logic_vector(unsigned(bcd_reg(15 downto 12)) + 3);
                    end if;

                    -- Shift: voy metiendo en 
                    bcd_reg := bcd_reg(14 downto 0) & bin(9);
                    bin := bin(8 downto 0) & '0';
                end loop;

                bcd <= bcd_reg;
            end if;
        end if;
    end process;

    -- Separación de dígitos
    und <= bcd(3 downto 0);
    dec <= bcd(7 downto 4);
    cen <= bcd(11 downto 8);
    mil <= bcd(15 downto 12);
  
  --contador 1ms
    process(clk, reset)
    begin 
        if(reset = '1') then 
            contador_uns <= "0001";
        elsif(clk' event and clk = '1') then 
        if(ovf_1ms = '1')then
            if ( contador_uns < contador_uns_MAX) then
            contador_uns <= contador_uns + 1; 
        else
            contador_uns <= "0001"; 
        end if; 
        end if; 
        end if;
    end process; 
 
 --selector display      
with contador_uns select
    selector <= "0001" when "0001",
                "0010" when "0010",
                "0100" when "0011",
                "1000" when "0100",
                "0000" when others;
  
------------MULTIPLEXOR---------------
with contador_uns select
    decodificador <= unsigned(und) when "0001",
                     unsigned(dec) when "0010",
                     unsigned(cen) when "0011",
                     unsigned(mil) when "0100",
                     "0000" when others;
         
------------DECODIFICADOR--------------
with decodificador select
    segmentos <= "0000001" when "0000",
                 "1001111" when "0001", 
                 "0010010" when "0010",
                 "0000110" when "0011",
                 "1001001" when "0100",
                 "0100100" when "0101",
                 "0100000" when "0110",
                 "0001111" when "0111",
                 "0000000" when "1000",
                 "0000100" when "1001",
                 "0000001" when others;
  
end Behavioral;
