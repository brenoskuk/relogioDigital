-- VHDL contador de 0 a 6 up down com clear assincrono --

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity contador6 is
	port(clock		: in std_logic;
		  clear		: in std_logic;
		  load 		: in std_logic;
		  dir  		: in std_logic;
		  enable		: in std_logic;
		  data		: in std_logic_vector (3 downto 0); 
		  rco     	: out std_logic;
		  Q    		: out std_logic_vector(3 downto 0)
		  
		 );	 
end contador6;			

architecture comportamental of contador6 is

begin
	process (clock, enable, clear, load, dir)
	--variavel temp que sera usada para armazenar os valores temporarios -- 
	variable temp : unsigned (3 downto 0);
	begin
		-- sincronicidade ocorre dentro deste if --
		if clock'event and clock = '1' then
			-- se enable for 1 realiza contagem --
			if enable = '1' and dir = '1' then	
				temp := temp + 1;
				
			elsif enable = '1' and dir = '0' then
				temp := temp - 1;
				
			end if;
			-- se estourou a contagem e dir eh 1 --	
			if conv_integer(temp) > 6 and dir = '1' then
				temp := "0000";
			-- se dir eh 0 --
			elsif conv_integer(temp) > 6 and dir = '0' then
					temp := "0110";
			end if;
			
			-- carrega data em load independente da contagem temp --	
			if load = '1' then
				temp := unsigned(data);
			end if;	
		end if;
	
-- clear assincrono joga os valores para zero independente do que ocorreu
		if clear = '1' then
			temp := (others=> '0');
		end if;	

		Q <= std_logic_vector(temp);
		
		--Para emitir RCO mesmo com o LOAD ativo ou clear e dir = 0 --
		-- caso em que conta positivo--
		if dir = '1' then
			if conv_integer(temp) = 6 then
				rco <= '1';
			else
				rco <= '0';
			end if;
		--caso em que conta negativo--
		elsif dir = '0' then
			if conv_integer(temp) = 0 then
				rco <= '1';
			else 
				rco <= '0';
			end if;
		end if;	
		
		
	end process;
end comportamental;