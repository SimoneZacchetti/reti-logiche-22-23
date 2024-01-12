----------------------------------------------------------------------------------
-- University: Politecnico di Milano
-- Students: Xin Ye, Simone Zacchetti
-- 
-- Create Date: 03/09/2023 07:47:05 PM
-- Design Name: project reti logiche 2022/2023
-- Module Name: project_reti_logiche - Behavioral
-- Project Name: project reti logiche 2022/2023
-- Target Devices: All
-- Tool Versions: Vivado 2018.3.1, Vivado 2016.4
-- Description: This is the final project presented by the students for Prova finale di reti logiche
-- 
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


-- ENTITY

entity project_reti_logiche is
         port (
             i_clk   : in std_logic;
             i_rst   : in std_logic;
             i_start : in std_logic;
             i_w     : in std_logic;
             o_z0    : out std_logic_vector(7 downto 0);
             o_z1    : out std_logic_vector(7 downto 0);
             o_z2    : out std_logic_vector(7 downto 0);
             o_z3    : out std_logic_vector(7 downto 0);
             o_done  : out std_logic;
             o_mem_addr : out std_logic_vector(15 downto 0);
             i_mem_data : in std_logic_vector(7 downto 0);
             o_mem_we   : out std_logic;
             o_mem_en   : out std_logic
         );
     end project_reti_logiche;


-- BEHAVIORAL ENTITY

architecture Behavioral of project_reti_logiche is
component datapath is 
    Port ( 
           i_clk : in std_logic;
           i_rst : in std_logic;
           i_w : in std_logic;
           r0_load : in std_logic;
           r1_load : in std_logic;
           r2_load : in std_logic;
           r3_load : in std_logic;
           demux_sel : in std_logic;
           concat_sel : in std_logic;
           r3_init : in std_logic;
           mux_sel : in std_logic;
           o_mem_addr : out std_logic_vector (15 downto 0);
           i_mem_data : in std_logic_vector (7 downto 0);
           o_done : out std_logic;
           i_done : in std_logic;
           reg_en : in std_logic;
           o_z0 : out std_logic_vector(7 downto 0);
           o_z1 : out std_logic_vector(7 downto 0);
           o_z2 : out std_logic_vector(7 downto 0);
           o_z3 : out std_logic_vector(7 downto 0)
           );
end component;

signal r0_load : std_logic;
signal r1_load : std_logic;
signal r2_load : std_logic;
signal r3_load : std_logic;
signal demux_sel : std_logic;
signal concat_sel : std_logic;
signal r3_init : std_logic;
signal mux_sel : std_logic;
signal i_done : std_logic;
signal reg_en : std_logic;
type S is (S0, S1, S2, S3, S4, S5, S6, S7);
signal cur_state, next_state : S;

begin
    DATAPATH0: datapath port map(
        i_clk => i_clk,
        i_rst => i_rst,
        i_w => i_w, 
        r0_load => r0_load,
        r1_load => r1_load,
        r2_load => r2_load,
        r3_load => r3_load,
        demux_sel => demux_sel,
        concat_sel => concat_sel,
        r3_init => r3_init,
        mux_sel => mux_sel,
        o_mem_addr => o_mem_addr,
        i_mem_data => i_mem_data,
        o_done => o_done,
        i_done => i_done,
        reg_en => reg_en,
        o_z0 => o_z0,
        o_z1 => o_z1,
        o_z2 => o_z2,
        o_z3 => o_z3
    );


    process(i_clk,i_rst)
    begin
        if(i_rst='1') then
            cur_state <= S0;
        elsif rising_edge(i_clk) then
            cur_state <= next_state;
        end if;
    end process;

    process(cur_state, i_start)
    begin 
        next_state <= cur_state;
        case cur_state is 
            when S0 =>
                if i_start = '1' then
                    next_state <= S1;
                end if;
            when S1 =>
                next_state <= S2;
            when S2 =>
                if i_start = '1' then
                    next_state <= S3;
                elsif i_start = '0' then
                    next_state <= S5;
                end if;
            when S3 =>
                if i_start = '0' then
                    next_state <= S4;
                end if;
            when S4 =>
                next_state <= S5;
            when S5 =>
                next_state <= S6;
            when S6 =>
                next_state <= S7;
            when S7 =>
                next_state <= S0;
         end case;
    end process;
         
    process(cur_state)
        begin
            r0_load <= '1';
            demux_sel <= '1';
            r3_init <= '1';
            r1_load <= '0';
            r2_load <= '0';
            r3_load <= '0';
            mux_sel <= '0';
            concat_sel <= '0';
            i_done <= '0';
            o_mem_en <= '0';
            o_mem_we <= '0';
            reg_en <= '0';
            case cur_state is 
                when S0 =>
                    r2_load <= '1';
                when S1 => 
                    r0_load <= '1';
                    demux_sel <= '0';
                    concat_sel <= '0';
                    r1_load <= '1';
                    r3_init <= '1';
                    mux_sel <= '0';
                    r2_load <= '1';
                when S2 =>
                    r0_load <= '1';
                    demux_sel <= '0';
                    concat_sel <= '1';
                    r3_init <= '1';
                    mux_sel <= '0';
                    r2_load <= '1';
                    o_mem_en <= '1';
                    r3_load <= '1';
                when S3 =>
                    r0_load <= '1';
                    demux_sel <= '1';
                    r3_init <= '0';
                    mux_sel <= '1';
                    r2_load <= '1';
                    concat_sel <= '0';
                    r1_load <= '0';
                when S4 =>
                    r0_load <= '1';
                    demux_sel <= '1';
                    r3_init <= '0';
                    mux_sel <= '1';
                    r2_load <= '1';
                    concat_sel <= '0';
                    r1_load <= '0';
                    o_mem_en <= '1';
                when S5 =>
                    reg_en <= '1';
                when S6 =>
                    i_done <= '1';
                when S7 =>
            end case;
    end process;
end Behavioral;                  


-- DATAPATH

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity datapath is 
    Port ( 
           i_clk : in std_logic;
           i_rst : in std_logic;
           i_w : in std_logic;
           r0_load : in std_logic;
           r1_load : in std_logic;
           r2_load : in std_logic;
           r3_load : in std_logic;
           demux_sel : in std_logic;
           concat_sel : in std_logic;
           r3_init : in std_logic;
           mux_sel : in std_logic;
           o_mem_addr : out std_logic_vector (15 downto 0);
           i_mem_data : in std_logic_vector (7 downto 0);
           o_done : out std_logic;
           i_done : in std_logic;
           reg_en : in std_logic;
           o_z0 : out std_logic_vector(7 downto 0);
           o_z1 : out std_logic_vector(7 downto 0);
           o_z2 : out std_logic_vector(7 downto 0);
           o_z3 : out std_logic_vector(7 downto 0)
           );
end datapath;

architecture Behavioral of datapath is 

signal o_reg0 : std_logic;
signal demux_sel0 : std_logic;
signal demux_sel1 : std_logic;
signal o_concat1 : std_logic_vector (1 downto 0);
signal o_reg1 : std_logic_vector (1 downto 0);
signal concat_sel0 : std_logic_vector (1 downto 0);
signal concat_sel1 : std_logic_vector (1 downto 0);
signal o_r3 : std_logic;
signal o_concat2 : std_logic_vector (15 downto 0);
signal o_mux_sel : std_logic_vector (15 downto 0);
signal o_reg2 : std_logic_vector (15 downto 0);
signal o_regz0 : std_logic_vector (7 downto 0);
signal o_regz1 : std_logic_vector (7 downto 0);
signal o_regz2 : std_logic_vector (7 downto 0);
signal o_regz3 : std_logic_vector (7 downto 0);
signal r_z0_load : std_logic;
signal r_z1_load : std_logic;
signal r_z2_load : std_logic;
signal r_z3_load : std_logic;
signal i_dec : std_logic_vector (1 downto 0);

begin
    --reg0
    process(i_clk, i_rst)
    begin 
        if(i_rst = '1') then
            o_reg0 <= '0';
        elsif rising_edge(i_clk) then
            if(r0_load = '1') then
                o_reg0 <= i_w;
            end if;
        end if;
    end process;
    
    --reg1
    process(i_clk, i_rst)
    begin 
        if(i_rst = '1') then
            o_reg1 <= "00";
        elsif rising_edge(i_clk) then
            if(r1_load = '1') then
                o_reg1 <= concat_sel0;
            end if;
        end if;
    end process;
    
    --reg2
    process(i_clk, i_rst)
    begin 
        if(i_rst = '1') then
            o_reg2 <= "0000000000000000";
        elsif rising_edge(i_clk) then
            if(r2_load = '1') then
                o_reg2 <= o_mux_sel;
            end if;
        end if;
    end process;
    
    --reg3
    process(i_clk, i_rst)
    begin 
        if(i_rst = '1') then
            i_dec <= "XX";
        elsif rising_edge(i_clk) then
            if(r3_load = '1') then
                i_dec <= concat_sel1;
            end if;
        end if;
    end process;
        
    --concat1 da 2 bit
    process(i_clk, i_rst, o_reg1, demux_sel0)
        variable tmp : std_logic_vector (2 downto 0);
        begin
            tmp := o_reg1 & demux_sel0;
            o_concat1(1) <= tmp(1);
            o_concat1(0) <= tmp(0);
    end process;
        
    --concat2 da 16 bit
    process(i_clk, i_rst, o_reg2, o_r3)
        variable tmp : std_logic_vector (16 downto 0);
        begin
            tmp := o_reg2 & o_r3 ;
            o_concat2(15) <= tmp(15);
            o_concat2(14) <= tmp(14);
            o_concat2(13) <= tmp(13);
            o_concat2(12) <= tmp(12);
            o_concat2(11) <= tmp(11);
            o_concat2(10) <= tmp(10);
            o_concat2(9) <= tmp(9);
            o_concat2(8) <= tmp(8);
            o_concat2(7) <= tmp(7);
            o_concat2(6) <= tmp(6);
            o_concat2(5) <= tmp(5);
            o_concat2(4) <= tmp(4);
            o_concat2(3) <= tmp(3);
            o_concat2(2) <= tmp(2);
            o_concat2(1) <= tmp(1);
            o_concat2(0) <= tmp(0);
    end process;
    
    o_mem_addr <= o_reg2;
    
    -- demux_sel
	with demux_sel select
		demux_sel0 <= o_reg0 when '0',
		              'X' when others;
    with demux_sel select 
		demux_sel1 <= 'X' when '0',
		               o_reg0 when others;
    
    -- concat_sel
	with concat_sel select
		concat_sel0 <= o_concat1 when '0',
		               "XX" when others;
	with concat_sel select
		concat_sel1 <= o_concat1 when '1',
		               "XX" when others; -- crea latch?
		               
    

    -- MUX r3_init
    with r3_init select
        o_r3 <= demux_sel1 when '0',
                '0' when '1',
                'X' when others;
    
    -- mux_sel
    with mux_sel select 
    o_mux_sel <= "0000000000000000" when '0',
                o_concat2 when '1',
                "XXXXXXXXXXXXXXXX" when others;
   
    -- i 4 MUX finali
    with i_done select
    o_z0 <= o_regz0 when '1',
            "00000000" when '0',
            "XXXXXXXX" when others;
    with i_done select
    o_z1 <= o_regz1 when '1',
            "00000000" when '0',
            "XXXXXXXX" when others;
    with i_done select
    o_z2 <= o_regz2 when '1',
            "00000000" when '0',
           "XXXXXXXX" when others;
    with i_done select
    o_z3 <= o_regz3 when '1',
            "00000000" when '0',
            "XXXXXXXX" when others;
    
    o_done <= i_done;
    
          

     
    process(i_clk, i_rst, i_dec)
    begin 
        --DECODER (da fare con un process?????)
        if (i_dec = "00") then
            r_z0_load <= '1';
            r_z1_load <= '0';
            r_z2_load <= '0';
            r_z3_load <= '0';   
        elsif (i_dec = "01") then
            r_z0_load <= '0';
            r_z1_load <= '1';
            r_z2_load <= '0';
            r_z3_load <= '0';
        elsif (i_dec = "10") then
            r_z0_load <= '0';
            r_z1_load <= '0';
            r_z2_load <= '1';
            r_z3_load <= '0';
        elsif (i_dec = "11") then
            r_z0_load <= '0';
            r_z1_load <= '0';
            r_z2_load <= '0';
            r_z3_load <= '1';
        else 
            r_z0_load <= 'X';
            r_z1_load <= 'X';
            r_z2_load <= 'X';
            r_z3_load <= 'X';
        end if;

        
        -- reg_z0
        if(i_rst = '1') then
             o_regz0 <= "00000000";
        elsif rising_edge(i_clk) then
            if(r_z0_load = '1' and reg_en = '1') then
                o_regz0 <= i_mem_data;
            end if;
         end if;

        -- reg_z1
        if(i_rst = '1') then
            o_regz1 <= "00000000";
        elsif rising_edge(i_clk) then
            if(r_z1_load = '1' and reg_en = '1') then
                o_regz1 <= i_mem_data;
            end if;
        end if;

        -- reg_z2
        if(i_rst = '1') then
            o_regz2 <= "00000000";
        elsif rising_edge(i_clk) then
            if(r_z2_load = '1' and reg_en = '1') then
                o_regz2 <= i_mem_data;
            end if;
        end if;

        -- reg_z3
        if(i_rst = '1') then
            o_regz3 <= "00000000";
        elsif rising_edge(i_clk) then
            if(r_z3_load = '1' and reg_en = '1') then
                o_regz3 <= i_mem_data;
            else
                o_regz3 <= o_regz3;
            end if;
        end if;
    end process;
    
end architecture;
