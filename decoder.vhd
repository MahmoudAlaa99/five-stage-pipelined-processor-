
LIBRARY IEEE; 
USE IEEE.std_logic_1164.all; 

entity dec is
  port (
  input : in std_logic_vector(1 downto 0);
  output : out std_logic_vector (3 downto 0);
  en : in std_logic);
  end dec;
  
  architecture decoder of dec is
    begin 
      
      output <= "0001" when input = "00" and en = '1' 
    else "0010" when input ="01" and en ='1'
      else "0100" when input ="10" and en ='1'
        else "1000" when input ="11" and en ='1';
      
    end decoder;
          