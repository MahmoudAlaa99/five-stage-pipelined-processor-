
LIBRARY IEEE; 
USE IEEE.std_logic_1164.all;

 ENTITY CCR IS 
 PORT( Set_clr_carry,en,dec_en,clk,rst,ALU_cout : IN std_logic;
       decoder : in std_logic_Vector(1 downto 0);
       ALU : IN std_logic_Vector(31 downto 0);
    CF,ZF,NF : INOUT std_logic;
    enable :in std_logic);
     END CCR;
     
ARCHITECTURE a_CCR OF CCR IS 


    
component dec is
  port (
  input : in std_logic_vector(1 downto 0);
  output : out std_logic_vector (3 downto 0);
  en : in std_logic);
  end component dec;
  
   signal dec_out : std_logic_vector(3 downto 0);
    signal C,N,Z :std_logic;
    
BEGIN   
  
    fx: dec PORT MAP(decoder,dec_out,dec_en);
      
PROCESS(clk,rst) 
BEGIN 
 IF falling_edge(clk) 
  THEN if en ='1'
  then   CF <= ALU_cout;
  end if;
 IF (ALU = x"00000000")
 THEN ZF <= '1';
   NF <= '0';
 else
   ZF <= '0';
 end if;
IF ALU(31) = '1'
THEN NF <= '1' ;
else
  NF<= '0';
end if;
  end if;
  
  IF(rst = '1') 
THEN CF <= '0' ;
ZF <= '0' ;
NF <= '0' ;
end if;
if (Set_clr_carry = '1')
then CF <= '0';
end if;
   
 
   
    
  if (dec_out ="0001")
  then if CF='1'
       then CF <= '0';
     end if;
   elsif (dec_out ="0010")
   then if ZF= '1'
  then ZF <= '0'; 
  end if;
elsif (dec_out ="0100" )
  then if (NF= '1')
    then NF <= '0' ;
end if;
end if;

END PROCESS;
  
   END a_CCR;
