----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.05.2025 13:21:05
-- Design Name: 
-- Module Name: TOP - Behavioral
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

entity TOP is
  Port (
    vaux1_v_n   : in std_logic;                          --Un ADC va de 0 a 8 y el otro de 9 a 16 (vaux), cojo el 1 y el 9 que son A0 y A1
    vaux1_v_p   : in std_logic; 
    vaux9_v_n   : in std_logic; 
    vaux9_v_p   : in std_logic; 
    clk_t         : in std_logic; 
    rst_t         : in std_logic; 
    start_t       : in std_logic;
    pwm_t         : out std_logic;
    segmentos_t 	: out std_logic_vector(6 downto 0);
    selector_t 	: out std_logic_vector(3 downto 0)
   );
   
end TOP;

architecture Behavioral of TOP is
    constant val            : std_logic := '0';
    signal daddr            : std_logic_vector(6 downto 0);
    signal den, drdy, dwe   : std_logic;
    signal di, do           : std_logic_vector(15 downto 0); 
        
     
     --Multiplicacion
     signal en_multiplicacion1_t  :  std_logic;
     signal en_multiplicacion2_t  :  std_logic;
     signal A_t                   : std_logic_vector(23 downto 0); -----V
     signal B_t                   : std_logic_vector(23 downto 0); -----I
     signal result_t              : std_logic_vector (47 downto 0);
     signal result_fin            : std_logic_vector (11 downto 0);
     signal finished_t            : std_logic; 
          
     --Contadores
     signal ovf_10ms  : std_logic;  --Pulso cada 10 ms
     signal ovf_2s    : std_logic;
     signal ovf_1ms   : std_logic;
     
     --Control
     signal ready_t    : std_logic;
     signal start_m    : std_logic;
     signal operando_t : std_logic;
     signal A_in       : std_logic_vector(23 downto 0);
     signal B_in       : std_logic_vector(23 downto 0);
     
begin
    xadc_controller_inst : entity work.xadc_controller
      PORT MAP(
            clk_i      => clk_t,
            daddr_o    => daddr,
            den_o      => den,
            di_o       => di,
            do_i       => do, 
            drdy_i     => drdy,
            dwe_o      => dwe,
            data_V     => A_t, 
            data_I     => B_t,
            rst_i      => rst_t,             
            start_i    => start_t,                   --Enable para que empiece a recibir datos
            ovf_10ms_i => ovf_10ms,
            ovf_2s_i   => ovf_2s, 
            ready      => ready_t
        );
        
    PWM_inst: entity work.pwm
    PORT MAP (
            clk     => clk_t,          -- Reloj de sistema 
            pwm_out => pwm_t          -- Señal PWM de salida 
    );
    
    multiplicacion_inst: entity work.multiplicacion
    PORT MAP (
            clk      => clk_t,                  
            rst      => rst_t,
            start    => start_m,                                 
            A        => A_in,                   
            B        => B_in,                                    
            result   => result_t,
            finished => finished_t,
            operando => operando_t         
    );
    
    control_inst: entity work.control
        port map(
            clk_c           => clk_t,           
            rst_c           => rst_t,        
            ready           => ready_t,      
            finished_c      => finished_t,
            operando_c	    => operando_t,
            start_c         => start_m, 
            result_c        => result_t,
            A_c             => A_t,
            B_c             => B_t,
            resultado_fin   => result_fin,
            Multiplicando   => A_in,      
            Multiplicador   => B_in,      
            ovf_1ms         => ovf_1ms,
            ovf_2s          => ovf_2s   
        );
    
    bin2bcd_inst: entity work.bin2bcd
    PORT MAP(
         clk        => clk_t, 
         reset      => rst_t, 
         num_bin    => result_fin, 
         segmentos  => segmentos_t, 	
         selector   => selector_t 
    );
    
    counter_inst: entity work.counter
    PORT MAP(
         clk        => clk_t,
         rst        => rst_t,
         ovf_10ms   => ovf_10ms,
         ovf_1ms    => ovf_1ms,
         ovf_2s     => ovf_2s    
    );
        
--Forma más sencilla de concetar los puertos, en vez de primero component y luego portmap
    xadc_inst: entity work.xadc_wiz_0
      PORT MAP (
        di_in       => di,				--Input data
        daddr_in    => daddr,			--Address bus
        den_in      => den,				--Enable signal
        dwe_in      => dwe,				--Write enable
        drdy_out    => drdy,			--Data ready
        do_out      => do,				--Output data
        dclk_in     => clk_t,
        reset_in    => rst_t,
        vp_in       => val,				--Analog input (le asigno 0 porq estoy usando vaux)
        vn_in       => val,				--Analog input
        vauxp1      => vaux1_v_p,
        vauxn1      => vaux1_v_n,
        vauxp9      => vaux9_v_p,
        vauxn9      => vaux9_v_n,
        channel_out => open,			
        eoc_out     => open,			
        alarm_out   => open,
        eos_out     => open,			
        busy_out    => open
      );

end Behavioral;

