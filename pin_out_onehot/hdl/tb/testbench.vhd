library ieee;
use ieee.std_logic_1164.all;


entity testbench is
end entity;

architecture v1 of testbench is

    type tSim is (ghdl, yosys);

    constant cSim: tSim := ghdl;
    constant cMax_w: natural := 64;
    constant cMin_w: natural := 2;
    constant cTest_time: time := 10 us; -- time to run tests, exit 0 after it

    component pin_out_onehot
        port (
            iControl: in std_logic_vector; -- len = port_num*port_num

            oControl: out std_logic_vector -- len = port_num*(port_num-1)
        );
    end component;

    component tester
        port (
            iControl: in std_logic_vector; -- len = port_num*(port_num-1)
            oControl: out std_logic_vector; -- len = port_num*port_num
            oDone: out std_logic;
            oError: out std_logic
        );
    end component;
    
    signal sDone: std_logic_vector (cMax_w downto cMin_w);
    signal sError: std_logic_vector (cMax_w downto cMin_w);

begin

    process
    begin
        wait until sDone = (sDone'range => '1');
        assert false report "sim done at " & time'image(now) severity note;
        case cSim is
            when ghdl =>
                wait;
            when yosys =>
                assert false severity failure;
            when others =>
                assert false report "unhandled sim type" severity failure;
        end case;
    end process;
    
	assert sError = (sError'range => '0')
		report "error trap. exiting"
		severity failure;

    widths: for i in cMin_w to cMax_w generate
        signal sFull: std_logic_vector (i*i-1 downto 0);
        signal sPartial: std_logic_vector (i*(i-1)-1 downto 0);
    begin
    
    	uut: pin_out_onehot
            port map (
                iControl => sFull,
                oControl => sPartial
            );

        tester_inst: tester
            port map (
                iControl => sPartial,
                oControl => sFull,
                oDone => sDone (i),
                oError => sError (i)
            );

    end generate;

end v1;
