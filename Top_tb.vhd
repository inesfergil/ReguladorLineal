----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.05.2025 17:35:10
-- Design Name: 
-- Module Name: Top_tb - Behavioral
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

entity Top_tb is
end Top_tb;

architecture Behavioral of Top_tb is
    component TOP is
        Port (
            vaux1_v_n   : in std_logic;                          --Un ADC va de 0 a 8 y el otro de 9 a 16 (vaux), cojo el 1 y el 9 que son A0 y A1
            vaux1_v_p   : in std_logic; 
            vaux9_v_n   : in std_logic; 
            vaux9_v_p   : in std_logic; 
            clk_t       : in std_logic; 
            rst_t       : in std_logic; 
            start_t     : in std_logic;
            pwm_t       : out std_logic;
            segmentos_t : out std_logic_vector(6 downto 0);
            selector_t 	: out std_logic_vector(3 downto 0)
           );
    end component;
    

    constant CLK_PERIOD : time := 8 ns;
    signal clk, rst, start, select_chnl, pwm : std_logic;
    signal leds : std_logic_vector(11 downto 0);
    signal vaux1_n, vaux1_p, vaux9_n, vaux9_p  : std_logic;
    signal segmentos 	: std_logic_vector(6 downto 0);
    signal selector 	: std_logic_vector(3 downto 0);
    signal duty         :   unsigned(7 downto 0);  


begin
    
    dut : entity work.TOP
    port map (
        Vaux1_v_n   => vaux1_n,
        Vaux1_v_p   => vaux1_p,
        Vaux9_v_n   => vaux9_n,
        Vaux9_v_p   => vaux9_p,
        clk_t        => clk,
        rst_t         => rst,
        start_t       => start,
        pwm_t         => pwm,
        segmentos_t  => segmentos, 
        selector_t 	 => selector
        
    );
    
    uut : entity work.pwm
    port map(
        clk     => clk,        
        pwm_out => pwm         
    );

    clk_stimuli : process
    begin
        clk <= '1';
        wait for CLK_PERIOD/2;
        clk <= '0';
        wait for CLK_PERIOD/2;
    end process;
    
    dut_stimuli : process
    begin
        rst <= '1';
        start <= '0';
        vaux1_p <= '0';
        vaux1_n <= '0';
        vaux9_p <= '0';
        vaux9_n <= '0';
        wait for 5*CLK_PERIOD;
        
        rst <= '0';
        wait for 10000*CLK_PERIOD;
        
        start <= '1';
        wait for CLK_PERIOD;
        
        start <= '0';
        
        
        wait for 100000*CLK_PERIOD;
        wait;
    end process;


end Behavioral;
