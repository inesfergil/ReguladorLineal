----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.04.2025 16:18:31
-- Design Name: 
-- Module Name: xadc_controller - Behavioral
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

entity xadc_controller is
    generic(
        C_SAMPLE_FREQ : integer := 125;
        C_CHANNEL_1_ADDR : std_logic_vector (6 downto 0) := "0010001";
        C_CHANNEL_9_ADDR : std_logic_vector (6 downto 0) := "0011001" 
    );
        
    Port ( clk_i : in std_logic; 
           rst_i : in std_logic;
           
           -- User ports
           start_i          : in std_logic;
           data_V           : out std_logic_vector(23 downto 0);
           data_I           : out std_logic_vector(23 downto 0);
           --User ports end
           
           --DRP Interface
           den_o 	: out std_logic;
           daddr_o 	: out std_logic_vector(6 downto 0);
           di_o 	: out std_logic_vector(15 downto 0);
           do_i 	: in std_logic_vector(15 downto 0);
           drdy_i 	: in std_logic;
           dwe_o 	: out std_logic;
           ovf_10ms_i 	: in std_logic;
           ovf_2s_i 	: in std_logic;
           ready 	: out std_logic 
    );
           
           
end xadc_controller;

architecture Behavioral of xadc_controller is
    type STATES is (IDLE, ACQU, ESPERA, LEOV, LEOI);
    signal state_reg, state_next: STATES := IDLE;
    signal select_chnl_i    :  std_logic := '0';
    signal data_V_i           :  std_logic_vector(23 downto 0);
    signal data_I_i           :  std_logic_vector(23 downto 0);

begin
    --Asigno variables para ADC
    di_o <= (others => '0');
    dwe_o <= '0';

--Máquina de estados controlador
    process (state_reg, start_i, clk_i, rst_i)
    begin
        if rst_i ='1' then
            --daddr_o <= C_CHANNEL_1_ADDR;
            state_next <= state_reg;
            select_chnl_i <= '1';
            data_V <= (others => '0');  
            data_I <= (others => '0');
            data_V_I <= (others => '0');  
            data_I_i <= (others => '0');  
            ready <= '0'; 
        end if; 
        if rising_edge(clk_i) then
            case state_reg is 
            when IDLE =>
                den_o <= '0';
                if start_i='1' then
                    state_next <= ACQU; 
                end if; 
            when ACQU =>
                ready <= '0'; 
                den_o <= '1';           --enable del ADC
                if select_chnl_i = '1' then
                    daddr_o <= C_CHANNEL_9_ADDR;
                elsif select_chnl_i = '0' then
                    daddr_o <= C_CHANNEL_1_ADDR;
                end if;
                state_next <= ESPERA;  
            when ESPERA =>
                den_o <= '0';
                if drdy_i='1' then
                    if select_chnl_i = '1' then
                        state_next <= LEOV;
                    elsif select_chnl_i = '0' then
                        state_next <= LEOI;
                    end if;                   
                end if;
            when LEOV =>
                data_V_i <= data_V_i(23 downto 12) & do_i(15 downto 4);
                data_V <= data_V_i;
                select_chnl_i <='0'; 
                if ovf_10ms_i ='1' then
                            state_next <= ACQU; 
                end if;
            when LEOI =>
                data_I_i <= data_I_i(23 downto 12) & do_i(15 downto 4);
                data_I <= data_I_i;
                ready <= '1';
                select_chnl_i <='1';
                if ovf_2s_i ='1' then
                            state_next <= ACQU; 
                end if;
            end case;
       end if;
    end process;
    
--Actualización de estados, asigno a state_reg state_next. También hago aquí reset
    process(clk_i, rst_i)
    begin
        if clk_i'event and clk_i='1' then
            if rst_i='1' then 
                state_reg <= IDLE;
            else 
                state_reg <= state_next;
            end if;
         end if;
    end process;
    
end Behavioral;
