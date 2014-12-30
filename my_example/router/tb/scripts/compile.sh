#! /bin/sh -f

irun \
-uvm \
-elaborate \
-access rwc \
"$@" \
-f ${DRD_DESIGN_DIR}/dut.f \
-f ${DRD_TB_DIR}/hdl/tb.f \
-f ${DRD_TB_DIR}/sv/env.f
