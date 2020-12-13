name=pin_out_onehot
srcdir=/mnt/data/$name


# Test GHDL itself
ghdl --version # List the files (validating the fileshare/mount)ls $srcdir 

# Analyse sources
ghdl -a $srcdir/hdl/src/*.vhd
ghdl -a $srcdir/hdl/tb/*.vhd 

# Elaborate the top-level
ghdl -e testbench

# Run the simulation
ghdl -r testbench