LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
USE IEEE.numeric_std.all;

ENTITY processor IS
GENERIC ( n : integer := 32);
PORT( Clk,Rst,Int: IN std_logic;
	InPort: IN std_logic_vector(n-1 DOWNTO 0);
	OutPort: OUT std_logic_vector(n-1 DOWNTO 0)
);
END processor;

ARCHITECTURE a_processor OF processor IS

COMPONENT counter_reg IS
GENERIC ( n : integer := 32);
PORT( Clk,Rst,enable1,enable2 : IN std_logic;
		   d1,d2 : IN std_logic_vector(n-1 DOWNTO 0);
		   q : OUT std_logic_vector(n-1 DOWNTO 0));
END COMPONENT;

COMPONENT memory IS
	PORT(
		address : IN  std_logic_vector(6 DOWNTO 0);
		dataout : OUT std_logic_vector(15 DOWNTO 0));
END COMPONENT;

COMPONENT fulladder IS
GENERIC (n : integer := 32);
PORT   (a, b : IN std_logic_vector(n-1 DOWNTO 0) ;
             cin : IN std_logic;
             s : OUT std_logic_vector(n-1 DOWNTO 0);
             cout : OUT std_logic);
END COMPONENT;

COMPONENT instruction_divider IS
GENERIC ( n : integer := 16);
PORT(Clk: IN std_logic; 
     Sel: IN std_logic_vector(1 DOWNTO 0);
     Input: IN std_logic_vector(n-1 DOWNTO 0);
     Finish: OUT std_logic;
     Output: OUT std_logic_vector(2*n-1 DOWNTO 0));
END COMPONENT;

COMPONENT register_file IS
GENERIC ( n : integer := 32);
PORT(Clk,Rst: IN std_logic; 
     RegRead,RegWrite1,RegWrite2: IN std_logic;
     ReadAddr1,ReadAddr2: IN std_logic_vector(2 DOWNTO 0);
     WriteAddr1: IN std_logic_vector(2 DOWNTO 0);
     WriteData1: IN std_logic_vector(n-1 DOWNTO 0);
     WriteAddr2 : IN std_logic_vector(2 DOWNTO 0);
     WriteData2: IN std_logic_vector(n-1 DOWNTO 0);
     ReadData1,ReadData2: OUT std_logic_vector(n-1 DOWNTO 0));
END COMPONENT;

COMPONENT control_unit IS
GENERIC ( n : integer := 32);
PORT( Clk,Rst,Int,Finish: IN std_logic;
	OpCode: IN std_logic_vector(4 DOWNTO 0);
	q: OUT std_logic_vector(26 DOWNTO 0);
	RtiRet: OUT std_logic
);
END COMPONENT;

COMPONENT CCR IS 
PORT( Set_clr_carry,en,dec_en,clk,rst,ALU_cout : IN std_logic;
       decoder : in std_logic_Vector(1 downto 0);
       ALU : IN std_logic_Vector(31 downto 0);
    CF,ZF,NF : INOUT std_logic;
    enable :in std_logic);
END COMPONENT;

COMPONENT ALU is
GENERIC (n : integer := 32);
port( sel0: IN std_logic;
      sel1: IN std_logic;
      sel2: IN std_logic;
      sel3: IN std_logic;
      in1 , in2: IN std_logic_vector (n-1 DOWNTO 0);
      Carryout: OUT std_logic;
      Shift: IN std_logic_vector (5 DOWNTO 0);
      output: OUT std_logic_vector (n-1 DOWNTO 0));
END COMPONENT;

COMPONENT dataMemory IS
	PORT(
		clk : IN std_logic;
		MemWrite: IN std_logic;
		MemRead: IN std_logic;
		reset: IN std_logic;
		address : IN  std_logic_vector(19 DOWNTO 0);
		datain  : IN  std_logic_vector(31 DOWNTO 0);
		dataout : OUT std_logic_vector(31 DOWNTO 0));
END COMPONENT;

COMPONENT IntermediateBuffer IS
	GENERIC(N : integer := 32);
		PORT( 
		D: IN std_logic_vector(N - 1 DOWNTO 0); 
		EN: IN std_logic;
		INT: IN std_logic;
		BRANCH: IN std_logic;
		RET: IN std_logic;
		RTI: IN std_logic;
		HAZARDDETECT: IN std_logic;
		CLK: IN std_logic;
		RST: IN std_logic;
		Q: OUT std_logic_vector(N - 1 DOWNTO 0)
		);
END COMPONENT;
-----------------------------------------------------------------
SIGNAL PCAdderCOut,RtiRet,IDFinish,NotRtiRet: std_logic;
SIGNAL IDSel: std_logic_vector(1 DOWNTO 0);
SIGNAL FinishOut: std_logic_vector(3 DOWNTO 0);
SIGNAL FetchedInstruction: std_logic_vector(15 DOWNTO 0);
SIGNAL SignExtend: std_logic_vector(19 DOWNTO 0);
SIGNAL ControlUnitOut: std_logic_vector(26 DOWNTO 0);
SIGNAL FirstBuffer,FirstBufferIn: std_logic_vector(80 DOWNTO 0);
SIGNAL SecondBuffer,SecondBufferIn: std_logic_vector(184 DOWNTO 0);
SIGNAL PCOut,PCAdderOut,Instruction,ReadD1,ReadD2: std_logic_vector(n-1 DOWNTO 0);
-----------------------------------------------------------------
BEGIN

PC: counter_reg GENERIC MAP (n) PORT MAP(Clk,Rst,'1','0',PCAdderOut,PCOut,PCOut);
PCAdder: fulladder GENERIC MAP (n) PORT MAP(PCOut,"00000000000000000000000000000001",'0',PCAdderOut,PCAdderCOut);
IM: memory PORT MAP(PCOut,FetchedInstruction);
------------------------------
FirstBufferIn <= Int&InPort&FetchedInstruction&PCOut;
NotRtiRet <= not RtiRet;
B0: IntermediateBuffer GENERIC MAP (n=>81) PORT MAP(FirstBufferIn,NotRtiRet,'0','0','0','0','0',Clk,Rst,FirstBuffer);
------------------------------
IDSel <= SecondBuffer(157)&SecondBuffer(183);
ID: instruction_divider GENERIC MAP (n) PORT MAP(Clk,IDSel,FirstBuffer(47 DOWNTO 32),IDFinish,Instruction);
CU: control_unit GENERIC MAP (n) PORT MAP(Clk,Rst,Int,IDFinish,Instruction(31 DOWNTO 27),ControlUnitOut,RtiRet);
RF: register_file GENERIC MAP (n) PORT MAP(Clk,Rst,ControlUnitOut(24),'1','1',Instruction(26 DOWNTO 24),Instruction(23 DOWNTO 21),"000","00000000000000000000000000000001","000","00000000000000000000000000000001",ReadD1,ReadD2);
------------------------------
SecondBufferIn <= ControlUnitOut&IDFinish&FirstBuffer(80 DOWNTO 48)&ReadD1&ReadD2&"000"&Instruction(23 DOWNTO 19)&SignExtend&FirstBuffer(31 DOWNTO 0);
B1: IntermediateBuffer GENERIC MAP (n=>185) PORT MAP(SecondBufferIn,'1','0','0','0','0','0',Clk,Rst,SecondBuffer);
------------------------------

END a_processor;