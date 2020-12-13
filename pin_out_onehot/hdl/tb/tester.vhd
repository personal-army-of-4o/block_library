library ieee;
use ieee.std_logic_1164.all;


entity tester is
    port (
        iControl: in std_logic_vector; -- len = port_num*(port_num-1)
        oControl: out std_logic_vector; -- len = port_num*port_num
        
        oDone: out std_logic := '0';
        oError: out std_logic := '0'
    );
end entity;

architecture v1 of tester is

	constant cVerbose: boolean := false;
    constant cN: natural := oControl'length - iControl'length;

begin

    assert oControl'length = cN*cN
        report "width error"
        severity failure;
        
    process

        procedure step is
        begin
            wait for 1 ns;
        end procedure;

		procedure set (ia: natural; ja: natural; signal s: out std_logic_vector) is
		begin
			s <= (s'range => '0');
			s (cN*ia + ja) <= '1';
		end procedure;
		
		function mkword (ia:natural;  j: natural) return std_logic_vector is
			variable ret: std_logic_vector (cN-2 downto 0) := (others => '0');
		begin
			if j < ia then
				ret (j) := '1';
			elsif j > ia then
				ret (j-1) := '1';
			end if;
			return ret;
		end function;
		
		function tostr (v: std_logic_vector) return string is
		begin
			if v'length = 0 then
				return "";
			end if;
		    return std_logic'image(v(v'high)) & tostr(v(v'high-1 downto v'low));
		end function;
		
		function mkvector (i: natural; j: natural) return std_logic_vector is
			variable ret: std_logic_vector (cN*(cN-1)-1 downto 0) := (others => '0');
		begin
			if i < j then
				ret (i*(cN-1) + j-1) := '1';
			elsif i > j then
				ret (i*(cN-1) + j) := '1';
			end if;
			return ret;
		end function;
		
		procedure check (ia: natural; ja: natural; s: std_logic_vector) is
			variable vRight_vector: std_logic_vector (cN*(cN-1)-1 downto 0)
				:= mkvector (ia, ja);
		begin
			if s /= vRight_vector then
				report "w=" & integer'image(cN) & ": step " & integer'image(ia)
						& ":" & integer'image(ja) & " failed (0). got "
						& tostr(s) & " expected " & tostr(vRight_vector);
					oError <= '1';
			elsif cVerbose then
				report "passed: w=" & integer'image(cN) & ": step " & integer'image(ia)
						& ":" & integer'image(ja) & " failed (0). got "
						& tostr(s) & " expected " & tostr(vRight_vector);
			end if;
		end procedure;

    begin
        oControl <= (oControl'range => '0');
        step;
        assert iControl = (iControl'range => '0')
            report "w=" & integer'image(cN) & ": all zeros test failed"
            severity note;
            
        for i in 0 to cN-1 loop
            for j in 0 to cN-1 loop
            	set (i, j, oControl);
                step;
                check (i, j, iControl);
            end loop;
        end loop;
        report "w=" & integer'image(cN) & ": test passed";
        oDone <= '1';
        wait;
    end process;

end v1;