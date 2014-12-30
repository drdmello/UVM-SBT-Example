setenv PATH /pkg/qct/bin:${PATH}

setenv DRD_INCISIV_VERSION 14.10.012
setenv DRD_INCISIV_DIR /pkg/cadence/general/incisiv${DRD_INCISIV_VERSION}
setenv PATH ${DRD_INCISIV_DIR}/tools/bin:${PATH}
setenv CDS_LIC_FILE `/pkg/licenses/tools/bin/vendor2port.pl cadence`

setenv UVM_HOME `ncroot`/tools/uvm-1.1

setenv DRD_EXAMPLE_HOME `pwd`
setenv DRD_DESIGN_DIR ${DRD_EXAMPLE_HOME}/router/design
setenv DRD_TB_DIR ${DRD_EXAMPLE_HOME}/router/tb
setenv DRD_IN_CHAN_DIR ${DRD_EXAMPLE_HOME}/in_chan
setenv DRD_TESTS_DIR ${DRD_TB_DIR}/tests
