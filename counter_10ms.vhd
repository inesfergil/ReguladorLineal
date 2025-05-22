----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.05.2025 12:25:22
-- Design Name: 
-- Module Name: counter_10ms - Behavioral
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

entity counter is
  Port (
      clk       :in std_logic; 
      rst       :in std_logic;
      ovf_10ms  :out std_logic;  --Pulso cada 10 ms
      ovf_1ms   :out std_logic;
      ovf_2s    : out std_logic
  );
end counter;

architecture Behavioral of counter is
    constant MAX_COUNT_10 : integer:=1249999; --reloj 125MHz
    signal count_10       : integer:=0;
    signal ovf_10        : std_logic := '0'; 
    constant MAX_COUNT_2 : integer:=12500000; --reloj 125MHz
    signal count_2       : integer:=0;
    signal ovf_2        : std_logic := '0'; 
    constant MAX_COUNT_1m : integer:=124999; --reloj 125MHz
    signal count_1       : integer:=0;
    signal ovf_1        : std_logic := '0';
    signal select_chnl :  std_logic;                         --Señal para cambiar de canal de lectura del ADC

begin

    process (clk,rst)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                count_10 <= 0; 
                ovf_10 <= '0';
            elsif count_10 = MAX_COUNT_10 then
               count_10 <= 0; 
               ovf_10  <= '1'; -- Pulso alto por un ciclo 
           else
            count_10 <= count_10 + 1;
            ovf_10 <= '0';
           end if;
        end if;
    end process;
    
    ovf_10ms <= ovf_10;  
    
    process (clk,rst)
     begin
        if rising_edge(clk) then
            if rst = '1' then
                count_2 <= 0; 
                ovf_2 <= '0';
            elsif count_2 = MAX_COUNT_2 then
               count_2 <= 0; 
               ovf_2  <= '1'; -- Pulso alto por un ciclo 
           else
            count_2 <= count_2 + 1;
            ovf_2 <= '0';
           end if;
        end if;
    end process;
    ovf_2s <= ovf_2;  
    
    process (clk,rst)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                count_1 <= 0; 
                ovf_1 <= '0';
            elsif count_1 = MAX_COUNT_1m then
               count_1 <= 0; 
               ovf_1  <= '1'; -- Pulso alto por un ciclo 
           else
            count_1 <= count_1 + 1;
            ovf_1 <= '0';
           end if;
        end if;
    end process;
    
    ovf_1ms <= ovf_1;     
       
end Behavioral;
