----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.05.2025 14:19:16
-- Design Name: 
-- Module Name: control - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity control is
    Port (
        clk             : in std_logic; 
        rst             : in std_logic; 
        start           : out std_logic;
        en_adc          : out std_logic;
        result          : in std_logic_vector (23 downto 0);
        C               : out std_logic_vector(23 downto 0);
        D               : out std_logic_vector(23 downto 0);
        ovf_10ms        : in std_logic;  --Pulso cada 10 ms
        ovf_2s          : in std_logic;
        en_multiplicacion1  : out std_logic;
        en_multiplicacion2  : out std_logic
        );
end control;

---Falta por meter eesto start


architecture Behavioral of control is
    signal eleccion: std_logic; 
begin
    
    
    process(clk, rst)
    begin
        if rst ='1' then 
            en_multiplicacion1 <='0'; 
            en_multiplicacion2 <='0';
        end if; 
    end process;  

end Behavioral;
