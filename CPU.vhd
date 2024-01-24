-- Copyright (C) 2018  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details.

-- PROGRAM		"Quartus Prime"
-- VERSION		"Version 18.0.0 Build 614 04/24/2018 SJ Lite Edition"
-- CREATED		"Tue Jan 12 09:49:06 2021"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY CPU IS 
	PORT
	(
		MAX10_CLK1_50 :  IN  STD_LOGIC;
		SW :  IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
		HEX0 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX1 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX2 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX3 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX4 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX5 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		LEDR :  OUT  STD_LOGIC_VECTOR(9 DOWNTO 0)
		
	);
END CPU;

ARCHITECTURE bdf_type OF CPU IS 

-- COMPONENTS

component  instruction_decoder
	port (
        instruction : in std_logic_vector(15 downto 0);
        alu_opcode : out std_logic_vector(3 downto 0);
        alu_a_address : out std_logic_vector(3 downto 0);
        alu_b_address : out std_logic_vector(3 downto 0);
        register_write_enable : out std_logic;
	);
end component;

component register_file
	port(
		reset : in std_logic;
		clock : in std_logic;
		write_enable : in std_logic;

		address : in std_logic_vector(3 downto 0);
		data_in : in std_logic_vector(15 downto 0);

		addressA : in std_logic_vector(3 downto 0);
		data_outA : out std_logic_vector(15 downto 0);

		addressB : in std_logic_vector(3 downto 0);
		data_outB : out std_logic_vector(15 downto 0)
	);
end component;

component alu
	port (
		A : in std_logic_vector(15 downto 0); -- Input A
        B : in std_logic_vector(15 downto 0); -- Input B
        OP : in std_logic_vector(3 downto 0); -- Opcode
        Y : out std_logic_vector(15 downto 0); -- Result
        Z : out std_logic -- Zero flag
	);
end component;

component seg7_lut
	PORT(iDIG : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 oSEG : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
end component;

COMPONENT dig2dec
	PORT(vol : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 seg0 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 seg1 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 seg2 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 seg3 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 seg4 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;

-- SIGNALS

SIGNAL	zero :  STD_LOGIC;
SIGNAL	one :  STD_LOGIC;
SIGNAL	HEX_out0 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	HEX_out1 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	HEX_out2 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	HEX_out3 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	HEX_out4 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	seg7_in0 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	seg7_in1 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	seg7_in2 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	seg7_in3 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	seg7_in4 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	seg7_in5 :  STD_LOGIC_VECTOR(7 DOWNTO 0);

signal instruction : std_logic_vector(15 downto 0);
signal alu_opcode : std_logic_vector(3 downto 0);
signal alu_a_address : std_logic_vector(3 downto 0);
signal alu_b_address : std_logic_vector(3 downto 0);

signal rf_reset : std_logic;
signal rf_clock : std_logic := '0';
signal rf_write_enable : std_logic;
signal rf_address : std_logic_vector(3 downto 0);
signal rf_data_in : std_logic_vector(15 downto 0);

signal rf_data_outA : std_logic_vector(15 downto 0);

signal rf_data_outB : std_logic_vector(15 downto 0);

signal alu_result : std_logic_vector(15 downto 0);
signal alu_zero: std_logic;

-- BEHAVIORAL

BEGIN 

instruction_decoder_inst : instruction_decoder
port map (
	instruction => instruction,
	alu_opcode => alu_opcode,
	alu_a_address => alu_a_address,
	alu_b_address => alu_b_address,
	register_write_enable => rf_write_enable
);

reg_file_inst : register_file
port map(
	reset => rf_reset,
	clock => rf_clock,
	write_enable => rf_write_enable,
	address => rf_address,
	data_in => rf_data_in,
	addressA => alu_a_address,
	data_outA => rf_data_outA,
	addressB => alu_b_address,
	data_outB => rf_data_outB
);

alu_inst : alu
port map(
	A => rf_data_outA,
	B => rf_data_outB,
	OP => alu_opcode,
	Y => alu_result,
	Z => alu_zero
);

b2v_inst : seg7_lut
PORT MAP(iDIG => seg7_in0,
		 oSEG => HEX_out4(6 DOWNTO 0));


b2v_inst1 : seg7_lut
PORT MAP(iDIG => seg7_in1,
		 oSEG => HEX_out3(6 DOWNTO 0));

b2v_inst2 : seg7_lut
PORT MAP(iDIG => seg7_in2,
		 oSEG => HEX_out2(6 DOWNTO 0));


b2v_inst3 : seg7_lut
PORT MAP(iDIG => seg7_in3,
		 oSEG => HEX_out1(6 DOWNTO 0));


b2v_inst4 : seg7_lut
PORT MAP(iDIG => seg7_in4,
		 oSEG => HEX_out0(6 DOWNTO 0));


b2v_inst5 : dig2dec
PORT MAP(		 vol => "1101010110101010",
		 seg0 => seg7_in4,
		 seg1 => seg7_in3,
		 seg2 => seg7_in2,
		 seg3 => seg7_in1,
		 seg4 => seg7_in0);




HEX0 <= HEX_out0;
HEX1 <= HEX_out1;
HEX2 <= HEX_out2;
HEX3 <= HEX_out3;
HEX4 <= HEX_out4;
HEX5(7) <= one;
HEX5(6) <= one;
HEX5(5) <= one;
HEX5(4) <= one;
HEX5(3) <= one;
HEX5(2) <= one;
HEX5(1) <= one;
HEX5(0) <= one;

zero <= '0';
one <= '1';
HEX_out0(7) <= '1';
HEX_out1(7) <= '1';
HEX_out2(7) <= '1';
HEX_out3(7) <= '1';
HEX_out4(7) <= '1';

LEDR <= SW;

END bdf_type;