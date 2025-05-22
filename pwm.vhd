----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.05.2025 11:12:26
-- Design Name: 
-- Module Name: pwm - Behavioral
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
use IEEE.NUMERIC_STD.ALL; 

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pwm is
  Port (
    clk    : in  std_logic;         -- Reloj de sistema 
    duty   : in  unsigned(7 downto 0); -- Valor del ciclo útil (0-255) 
    pwm_out : out std_logic  -- Señal PWM de salida 
  );
end pwm;

architecture Behavioral of pwm is
    signal counter : unsigned(7 downto 0) := (others => '0');  -- 8 bits: 0–255

begin
    process(clk)
    begin
        if rising_edge(clk) then
            counter <= counter + 1;
        end if;
    end process;
 pwm_out <= '1' when counter < duty else '0';
 
end Behavioral;
