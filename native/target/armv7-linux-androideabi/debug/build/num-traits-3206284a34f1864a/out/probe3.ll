; ModuleID = 'probe3.ee7ecd8d-cgu.0'
source_filename = "probe3.ee7ecd8d-cgu.0"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "armv7-none-linux-android"

; probe3::probe
; Function Attrs: nonlazybind uwtable
define void @_ZN6probe35probe17h206d9268eb4b876fE() unnamed_addr #0 {
start:
  %0 = alloca i32, align 4
  store i32 1, i32* %0, align 4
  %1 = load i32, i32* %0, align 4
  br label %bb1

bb1:                                              ; preds = %start
  ret void
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare i32 @llvm.cttz.i32(i32, i1 immarg) #1

attributes #0 = { nonlazybind uwtable "target-cpu"="generic" "target-features"="+v7,+thumb-mode,+thumb2,+vfp3,-d32,-neon" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }

!llvm.module.flags = !{!0, !1}

!0 = !{i32 7, !"PIC Level", i32 2}
!1 = !{i32 2, !"RtLibUseGOT", i32 1}
