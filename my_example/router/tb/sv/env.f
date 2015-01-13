-f ${DRD_IN_CHAN_DIR}/sv/env.f
-f ${DRD_OUT_CHAN_DIR}/sv/env.f
+incdir+${DRD_TB_DIR}/sv
${DRD_TB_DIR}/sv/router_pkg.sv
${DRD_TESTS_DIR}/router_tests.sv
-coverage u
