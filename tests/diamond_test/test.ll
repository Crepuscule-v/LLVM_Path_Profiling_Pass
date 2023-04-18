; ModuleID = 'complex_test.cpp'
source_filename = "complex_test.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define dso_local noundef i32 @_Z8somefunci(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  store i32 0, ptr %3, align 4
  %4 = load i32, ptr %2, align 4
  %5 = icmp eq i32 %4, 0
  br i1 %5, label %6, label %7

6:                                                ; preds = %1
  store i32 5, ptr %3, align 4
  br label %7

7:                                                ; preds = %6, %1
  %8 = load i32, ptr %2, align 4
  %9 = icmp sle i32 %8, 0
  br i1 %9, label %10, label %13

10:                                               ; preds = %7
  %11 = load i32, ptr %3, align 4
  %12 = add nsw i32 %11, -12
  store i32 %12, ptr %3, align 4
  br label %18

13:                                               ; preds = %7
  %14 = load i32, ptr %2, align 4
  %15 = mul nsw i32 %14, 2
  %16 = load i32, ptr %3, align 4
  %17 = add nsw i32 %16, %15
  store i32 %17, ptr %3, align 4
  br label %18

18:                                               ; preds = %13, %10
  %19 = load i32, ptr %3, align 4
  %20 = mul nsw i32 %19, 3
  store i32 %20, ptr %3, align 4
  %21 = load i32, ptr %2, align 4
  %22 = icmp eq i32 %21, 5
  br i1 %22, label %23, label %26

23:                                               ; preds = %18
  %24 = load i32, ptr %3, align 4
  %25 = add nsw i32 %24, 4
  store i32 %25, ptr %3, align 4
  br label %26

26:                                               ; preds = %23, %18
  %27 = load i32, ptr %3, align 4
  %28 = add nsw i32 %27, 4
  ret i32 %28
}

; Function Attrs: mustprogress noinline norecurse nounwind optnone uwtable
define dso_local noundef i32 @main() #1 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  store i32 0, ptr %2, align 4
  %3 = call noundef i32 @_Z8somefunci(i32 noundef 10)
  %4 = load i32, ptr %2, align 4
  %5 = add nsw i32 %4, %3
  store i32 %5, ptr %2, align 4
  %6 = call noundef i32 @_Z8somefunci(i32 noundef -10)
  %7 = load i32, ptr %2, align 4
  %8 = add nsw i32 %7, %6
  store i32 %8, ptr %2, align 4
  %9 = call noundef i32 @_Z8somefunci(i32 noundef 0)
  %10 = load i32, ptr %2, align 4
  %11 = add nsw i32 %10, %9
  store i32 %11, ptr %2, align 4
  %12 = call noundef i32 @_Z8somefunci(i32 noundef 4)
  %13 = load i32, ptr %2, align 4
  %14 = add nsw i32 %13, %12
  store i32 %14, ptr %2, align 4
  %15 = load i32, ptr %2, align 4
  ret i32 %15
}

attributes #0 = { mustprogress noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { mustprogress noinline norecurse nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"Ubuntu clang version 15.0.7"}
