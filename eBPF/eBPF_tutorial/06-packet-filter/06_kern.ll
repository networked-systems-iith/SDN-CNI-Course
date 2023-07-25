; ModuleID = '06_kern.c'
source_filename = "06_kern.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.xdp_md = type { i32, i32, i32, i32, i32 }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }
%struct.hdr_cursor = type { i8* }
%struct.vlan_hdr = type { i16, i16 }
%struct.iphdr = type { i8, i8, i16, i16, i16, i8, i8, i16, %union.anon }
%union.anon = type { %struct.anon }
%struct.anon = type { i32, i32 }

@__const.xdp_parser_func.____fmt = private unnamed_addr constant [27 x i8] c"Dropping TCP packets...!!!\00", align 1
@__const.xdp_parser_func.____fmt.1 = private unnamed_addr constant [22 x i8] c"PASSING packets...!!!\00", align 1
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !0
@llvm.compiler.used = appending global [2 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_parser_func to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @xdp_parser_func(%struct.xdp_md* nocapture noundef readonly %0) #0 section "xdp_packet_filter" !dbg !71 {
  %2 = alloca [27 x i8], align 1
  %3 = alloca [22 x i8], align 1
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !83, metadata !DIExpression()), !dbg !147
  %4 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !148
  %5 = load i32, i32* %4, align 4, !dbg !148, !tbaa !149
  %6 = zext i32 %5 to i64, !dbg !154
  %7 = inttoptr i64 %6 to i8*, !dbg !155
  call void @llvm.dbg.value(metadata i8* %7, metadata !84, metadata !DIExpression()), !dbg !147
  %8 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !156
  %9 = load i32, i32* %8, align 4, !dbg !156, !tbaa !157
  %10 = zext i32 %9 to i64, !dbg !158
  %11 = inttoptr i64 %10 to i8*, !dbg !159
  call void @llvm.dbg.value(metadata i8* %11, metadata !85, metadata !DIExpression()), !dbg !147
  call void @llvm.dbg.value(metadata i8* %11, metadata !130, metadata !DIExpression()), !dbg !147
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !86, metadata !DIExpression(DW_OP_deref)), !dbg !147
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !160, metadata !DIExpression()) #6, !dbg !179
  call void @llvm.dbg.value(metadata i8* %7, metadata !167, metadata !DIExpression()) #6, !dbg !179
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !168, metadata !DIExpression()) #6, !dbg !179
  call void @llvm.dbg.value(metadata i8* %11, metadata !169, metadata !DIExpression()) #6, !dbg !179
  call void @llvm.dbg.value(metadata i32 14, metadata !178, metadata !DIExpression()) #6, !dbg !179
  %12 = getelementptr i8, i8* %11, i64 14, !dbg !181
  %13 = icmp ugt i8* %12, %7, !dbg !183
  br i1 %13, label %42, label %14, !dbg !184

14:                                               ; preds = %1
  call void @llvm.dbg.value(metadata i8* %11, metadata !169, metadata !DIExpression()) #6, !dbg !179
  call void @llvm.dbg.value(metadata i8* %12, metadata !130, metadata !DIExpression()), !dbg !147
  call void @llvm.dbg.value(metadata i8* %12, metadata !170, metadata !DIExpression()) #6, !dbg !179
  %15 = getelementptr inbounds i8, i8* %11, i64 12, !dbg !185
  %16 = bitcast i8* %15 to i16*, !dbg !185
  call void @llvm.dbg.value(metadata i16 undef, metadata !176, metadata !DIExpression()) #6, !dbg !179
  call void @llvm.dbg.value(metadata i32 0, metadata !177, metadata !DIExpression()) #6, !dbg !179
  call void @llvm.dbg.value(metadata i8* %12, metadata !170, metadata !DIExpression()) #6, !dbg !179
  %17 = inttoptr i64 %6 to %struct.vlan_hdr*
  call void @llvm.dbg.value(metadata i32 0, metadata !177, metadata !DIExpression()) #6, !dbg !179
  call void @llvm.dbg.value(metadata i8* %12, metadata !170, metadata !DIExpression()) #6, !dbg !179
  %18 = load i16, i16* %16, align 1, !dbg !179, !tbaa !186
  call void @llvm.dbg.value(metadata i16 %18, metadata !176, metadata !DIExpression()) #6, !dbg !179
  call void @llvm.dbg.value(metadata i16 %18, metadata !188, metadata !DIExpression()) #6, !dbg !193
  %19 = icmp eq i16 %18, 129, !dbg !199
  %20 = icmp eq i16 %18, -22392, !dbg !200
  %21 = tail call i1 @llvm.bpf.passthrough.i1.i1(i32 0, i1 %19) #6
  %22 = or i1 %20, %21, !dbg !200
  %23 = xor i1 %22, true, !dbg !201
  %24 = getelementptr i8, i8* %11, i64 18
  %25 = bitcast i8* %24 to %struct.vlan_hdr*
  %26 = icmp ugt %struct.vlan_hdr* %25, %17
  %27 = select i1 %23, i1 true, i1 %26, !dbg !202
  br i1 %27, label %42, label %28, !dbg !202

28:                                               ; preds = %14
  %29 = getelementptr i8, i8* %11, i64 16, !dbg !203
  %30 = bitcast i8* %29 to i16*, !dbg !203
  call void @llvm.dbg.value(metadata i16 undef, metadata !176, metadata !DIExpression()) #6, !dbg !179
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %25, metadata !170, metadata !DIExpression()) #6, !dbg !179
  call void @llvm.dbg.value(metadata i32 1, metadata !177, metadata !DIExpression()) #6, !dbg !179
  call void @llvm.dbg.value(metadata i32 1, metadata !177, metadata !DIExpression()) #6, !dbg !179
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %25, metadata !170, metadata !DIExpression()) #6, !dbg !179
  %31 = load i16, i16* %30, align 1, !dbg !179, !tbaa !186
  call void @llvm.dbg.value(metadata i16 %31, metadata !176, metadata !DIExpression()) #6, !dbg !179
  call void @llvm.dbg.value(metadata i16 %31, metadata !188, metadata !DIExpression()) #6, !dbg !193
  %32 = icmp eq i16 %31, 129, !dbg !199
  %33 = icmp eq i16 %31, -22392, !dbg !200
  %34 = tail call i1 @llvm.bpf.passthrough.i1.i1(i32 0, i1 %32) #6
  %35 = or i1 %33, %34, !dbg !200
  %36 = xor i1 %35, true, !dbg !201
  %37 = getelementptr i8, i8* %11, i64 22
  %38 = bitcast i8* %37 to %struct.vlan_hdr*
  %39 = icmp ugt %struct.vlan_hdr* %38, %17
  %40 = select i1 %36, i1 true, i1 %39, !dbg !202
  br i1 %40, label %42, label %41, !dbg !202

41:                                               ; preds = %28
  call void @llvm.dbg.value(metadata i16 undef, metadata !176, metadata !DIExpression()) #6, !dbg !179
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %38, metadata !170, metadata !DIExpression()) #6, !dbg !179
  call void @llvm.dbg.value(metadata i32 2, metadata !177, metadata !DIExpression()) #6, !dbg !179
  br label %42

42:                                               ; preds = %14, %28, %41, %1
  %43 = phi i8* [ %11, %1 ], [ %12, %14 ], [ %24, %28 ], [ %37, %41 ], !dbg !147
  call void @llvm.dbg.value(metadata i8* %43, metadata !130, metadata !DIExpression()), !dbg !147
  call void @llvm.dbg.value(metadata i32 undef, metadata !134, metadata !DIExpression()), !dbg !147
  call void @llvm.dbg.value(metadata %struct.iphdr** undef, metadata !100, metadata !DIExpression(DW_OP_deref)), !dbg !147
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !204, metadata !DIExpression()), !dbg !214
  call void @llvm.dbg.value(metadata i8* %7, metadata !210, metadata !DIExpression()), !dbg !214
  call void @llvm.dbg.value(metadata %struct.iphdr** undef, metadata !211, metadata !DIExpression()), !dbg !214
  call void @llvm.dbg.value(metadata i8* %43, metadata !212, metadata !DIExpression()), !dbg !214
  %44 = getelementptr inbounds i8, i8* %43, i64 20, !dbg !216
  %45 = icmp ugt i8* %44, %7, !dbg !218
  br i1 %45, label %62, label %46, !dbg !219

46:                                               ; preds = %42
  %47 = load i8, i8* %43, align 4, !dbg !220
  %48 = shl i8 %47, 2, !dbg !221
  %49 = and i8 %48, 60, !dbg !221
  call void @llvm.dbg.value(metadata i8 %49, metadata !213, metadata !DIExpression(DW_OP_LLVM_convert, 8, DW_ATE_unsigned, DW_OP_LLVM_convert, 64, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !214
  %50 = icmp ult i8 %49, 20, !dbg !222
  br i1 %50, label %62, label %51, !dbg !224

51:                                               ; preds = %46
  %52 = zext i8 %49 to i64
  call void @llvm.dbg.value(metadata i64 %52, metadata !213, metadata !DIExpression()), !dbg !214
  %53 = getelementptr i8, i8* %43, i64 %52, !dbg !225
  %54 = icmp ugt i8* %53, %7, !dbg !227
  br i1 %54, label %62, label %55, !dbg !228

55:                                               ; preds = %51
  call void @llvm.dbg.value(metadata i8* %53, metadata !130, metadata !DIExpression()), !dbg !147
  %56 = getelementptr inbounds i8, i8* %43, i64 9, !dbg !229
  %57 = load i8, i8* %56, align 1, !dbg !229, !tbaa !230
  call void @llvm.dbg.value(metadata i8 %57, metadata !134, metadata !DIExpression(DW_OP_LLVM_convert, 8, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !147
  %58 = icmp eq i8 %57, 6, !dbg !232
  br i1 %58, label %59, label %62, !dbg !233

59:                                               ; preds = %55
  %60 = getelementptr inbounds [27 x i8], [27 x i8]* %2, i64 0, i64 0, !dbg !234
  call void @llvm.lifetime.start.p0i8(i64 27, i8* nonnull %60) #6, !dbg !234
  call void @llvm.dbg.declare(metadata [27 x i8]* %2, metadata !135, metadata !DIExpression()), !dbg !234
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(27) %60, i8* noundef nonnull align 1 dereferenceable(27) getelementptr inbounds ([27 x i8], [27 x i8]* @__const.xdp_parser_func.____fmt, i64 0, i64 0), i64 27, i1 false), !dbg !234
  %61 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* noundef nonnull %60, i32 noundef 27) #6, !dbg !234
  call void @llvm.lifetime.end.p0i8(i64 27, i8* nonnull %60) #6, !dbg !235
  br label %65, !dbg !236

62:                                               ; preds = %51, %46, %42, %55
  %63 = getelementptr inbounds [22 x i8], [22 x i8]* %3, i64 0, i64 0, !dbg !237
  call void @llvm.lifetime.start.p0i8(i64 22, i8* nonnull %63) #6, !dbg !237
  call void @llvm.dbg.declare(metadata [22 x i8]* %3, metadata !142, metadata !DIExpression()), !dbg !237
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(22) %63, i8* noundef nonnull align 1 dereferenceable(22) getelementptr inbounds ([22 x i8], [22 x i8]* @__const.xdp_parser_func.____fmt.1, i64 0, i64 0), i64 22, i1 false), !dbg !237
  %64 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* noundef nonnull %63, i32 noundef 22) #6, !dbg !237
  call void @llvm.lifetime.end.p0i8(i64 22, i8* nonnull %63) #6, !dbg !238
  br label %65, !dbg !239

65:                                               ; preds = %62, %59
  %66 = phi i32 [ 1, %59 ], [ 2, %62 ], !dbg !147
  ret i32 %66, !dbg !240
}

; Function Attrs: mustprogress nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: argmemonly mustprogress nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #3

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #4

; Function Attrs: nounwind readnone
declare i1 @llvm.bpf.passthrough.i1.i1(i32, i1) #5

attributes #0 = { nounwind "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #1 = { mustprogress nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { argmemonly mustprogress nofree nosync nounwind willreturn }
attributes #3 = { argmemonly mustprogress nofree nounwind willreturn }
attributes #4 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #5 = { nounwind readnone }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!66, !67, !68, !69}
!llvm.ident = !{!70}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 159, type: !63, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !45, globals: !51, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "06_kern.c", directory: "/home/ubuntu/eBPF_tutorial/06-packet-filter", checksumkind: CSK_MD5, checksum: "102485448352fc71c53e8c804c7b17a9")
!4 = !{!5, !37}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !6, line: 28, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "/usr/include/linux/in.h", directory: "", checksumkind: CSK_MD5, checksum: "9a7f04155c254fef1b7ada5eb82c984c")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13, !14, !15, !16, !17, !18, !19, !20, !21, !22, !23, !24, !25, !26, !27, !28, !29, !30, !31, !32, !33, !34, !35, !36}
!9 = !DIEnumerator(name: "IPPROTO_IP", value: 0)
!10 = !DIEnumerator(name: "IPPROTO_ICMP", value: 1)
!11 = !DIEnumerator(name: "IPPROTO_IGMP", value: 2)
!12 = !DIEnumerator(name: "IPPROTO_IPIP", value: 4)
!13 = !DIEnumerator(name: "IPPROTO_TCP", value: 6)
!14 = !DIEnumerator(name: "IPPROTO_EGP", value: 8)
!15 = !DIEnumerator(name: "IPPROTO_PUP", value: 12)
!16 = !DIEnumerator(name: "IPPROTO_UDP", value: 17)
!17 = !DIEnumerator(name: "IPPROTO_IDP", value: 22)
!18 = !DIEnumerator(name: "IPPROTO_TP", value: 29)
!19 = !DIEnumerator(name: "IPPROTO_DCCP", value: 33)
!20 = !DIEnumerator(name: "IPPROTO_IPV6", value: 41)
!21 = !DIEnumerator(name: "IPPROTO_RSVP", value: 46)
!22 = !DIEnumerator(name: "IPPROTO_GRE", value: 47)
!23 = !DIEnumerator(name: "IPPROTO_ESP", value: 50)
!24 = !DIEnumerator(name: "IPPROTO_AH", value: 51)
!25 = !DIEnumerator(name: "IPPROTO_MTP", value: 92)
!26 = !DIEnumerator(name: "IPPROTO_BEETPH", value: 94)
!27 = !DIEnumerator(name: "IPPROTO_ENCAP", value: 98)
!28 = !DIEnumerator(name: "IPPROTO_PIM", value: 103)
!29 = !DIEnumerator(name: "IPPROTO_COMP", value: 108)
!30 = !DIEnumerator(name: "IPPROTO_SCTP", value: 132)
!31 = !DIEnumerator(name: "IPPROTO_UDPLITE", value: 136)
!32 = !DIEnumerator(name: "IPPROTO_MPLS", value: 137)
!33 = !DIEnumerator(name: "IPPROTO_ETHERNET", value: 143)
!34 = !DIEnumerator(name: "IPPROTO_RAW", value: 255)
!35 = !DIEnumerator(name: "IPPROTO_MPTCP", value: 262)
!36 = !DIEnumerator(name: "IPPROTO_MAX", value: 263)
!37 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !38, line: 2845, baseType: !7, size: 32, elements: !39)
!38 = !DIFile(filename: "../headers/linux/bpf.h", directory: "/home/ubuntu/eBPF_tutorial/06-packet-filter", checksumkind: CSK_MD5, checksum: "db1ce4e5e29770657167bc8f57af9388")
!39 = !{!40, !41, !42, !43, !44}
!40 = !DIEnumerator(name: "XDP_ABORTED", value: 0)
!41 = !DIEnumerator(name: "XDP_DROP", value: 1)
!42 = !DIEnumerator(name: "XDP_PASS", value: 2)
!43 = !DIEnumerator(name: "XDP_TX", value: 3)
!44 = !DIEnumerator(name: "XDP_REDIRECT", value: 4)
!45 = !{!46, !47, !48}
!46 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!47 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!48 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !49, line: 24, baseType: !50)
!49 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!50 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!51 = !{!0, !52}
!52 = !DIGlobalVariableExpression(var: !53, expr: !DIExpression())
!53 = distinct !DIGlobalVariable(name: "bpf_trace_printk", scope: !2, file: !54, line: 152, type: !55, isLocal: true, isDefinition: true)
!54 = !DIFile(filename: "../libbpf/src//build/usr/include/bpf/bpf_helper_defs.h", directory: "/home/ubuntu/eBPF_tutorial/06-packet-filter", checksumkind: CSK_MD5, checksum: "2601bcf9d7985cb46bfbd904b60f5aaf")
!55 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !56, size: 64)
!56 = !DISubroutineType(types: !57)
!57 = !{!58, !59, !62, null}
!58 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!59 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !60, size: 64)
!60 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !61)
!61 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!62 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !49, line: 27, baseType: !7)
!63 = !DICompositeType(tag: DW_TAG_array_type, baseType: !61, size: 32, elements: !64)
!64 = !{!65}
!65 = !DISubrange(count: 4)
!66 = !{i32 7, !"Dwarf Version", i32 5}
!67 = !{i32 2, !"Debug Info Version", i32 3}
!68 = !{i32 1, !"wchar_size", i32 4}
!69 = !{i32 7, !"frame-pointer", i32 2}
!70 = !{!"Ubuntu clang version 14.0.0-1ubuntu1"}
!71 = distinct !DISubprogram(name: "xdp_parser_func", scope: !3, file: !3, line: 116, type: !72, scopeLine: 117, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !82)
!72 = !DISubroutineType(types: !73)
!73 = !{!58, !74}
!74 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !75, size: 64)
!75 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !38, line: 2856, size: 160, elements: !76)
!76 = !{!77, !78, !79, !80, !81}
!77 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !75, file: !38, line: 2857, baseType: !62, size: 32)
!78 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !75, file: !38, line: 2858, baseType: !62, size: 32, offset: 32)
!79 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !75, file: !38, line: 2859, baseType: !62, size: 32, offset: 64)
!80 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !75, file: !38, line: 2861, baseType: !62, size: 32, offset: 96)
!81 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !75, file: !38, line: 2862, baseType: !62, size: 32, offset: 128)
!82 = !{!83, !84, !85, !86, !100, !130, !134, !135, !142}
!83 = !DILocalVariable(name: "ctx", arg: 1, scope: !71, file: !3, line: 116, type: !74)
!84 = !DILocalVariable(name: "data_end", scope: !71, file: !3, line: 118, type: !46)
!85 = !DILocalVariable(name: "data", scope: !71, file: !3, line: 119, type: !46)
!86 = !DILocalVariable(name: "eth", scope: !71, file: !3, line: 120, type: !87)
!87 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !88, size: 64)
!88 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !89, line: 168, size: 112, elements: !90)
!89 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "", checksumkind: CSK_MD5, checksum: "ab0320da726e75d904811ce344979934")
!90 = !{!91, !96, !97}
!91 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !88, file: !89, line: 169, baseType: !92, size: 48)
!92 = !DICompositeType(tag: DW_TAG_array_type, baseType: !93, size: 48, elements: !94)
!93 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!94 = !{!95}
!95 = !DISubrange(count: 6)
!96 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !88, file: !89, line: 170, baseType: !92, size: 48, offset: 48)
!97 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !88, file: !89, line: 171, baseType: !98, size: 16, offset: 96)
!98 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !99, line: 25, baseType: !48)
!99 = !DIFile(filename: "/usr/include/linux/types.h", directory: "", checksumkind: CSK_MD5, checksum: "52ec79a38e49ac7d1dc9e146ba88a7b1")
!100 = !DILocalVariable(name: "ip", scope: !71, file: !3, line: 121, type: !101)
!101 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !102, size: 64)
!102 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iphdr", file: !103, line: 87, size: 160, elements: !104)
!103 = !DIFile(filename: "/usr/include/linux/ip.h", directory: "", checksumkind: CSK_MD5, checksum: "042b09a58768855e3578a0a8eba49be7")
!104 = !{!105, !107, !108, !109, !110, !111, !112, !113, !114, !116}
!105 = !DIDerivedType(tag: DW_TAG_member, name: "ihl", scope: !102, file: !103, line: 89, baseType: !106, size: 4, flags: DIFlagBitField, extraData: i64 0)
!106 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u8", file: !49, line: 21, baseType: !93)
!107 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !102, file: !103, line: 90, baseType: !106, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!108 = !DIDerivedType(tag: DW_TAG_member, name: "tos", scope: !102, file: !103, line: 97, baseType: !106, size: 8, offset: 8)
!109 = !DIDerivedType(tag: DW_TAG_member, name: "tot_len", scope: !102, file: !103, line: 98, baseType: !98, size: 16, offset: 16)
!110 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !102, file: !103, line: 99, baseType: !98, size: 16, offset: 32)
!111 = !DIDerivedType(tag: DW_TAG_member, name: "frag_off", scope: !102, file: !103, line: 100, baseType: !98, size: 16, offset: 48)
!112 = !DIDerivedType(tag: DW_TAG_member, name: "ttl", scope: !102, file: !103, line: 101, baseType: !106, size: 8, offset: 64)
!113 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !102, file: !103, line: 102, baseType: !106, size: 8, offset: 72)
!114 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !102, file: !103, line: 103, baseType: !115, size: 16, offset: 80)
!115 = !DIDerivedType(tag: DW_TAG_typedef, name: "__sum16", file: !99, line: 31, baseType: !48)
!116 = !DIDerivedType(tag: DW_TAG_member, scope: !102, file: !103, line: 104, baseType: !117, size: 64, offset: 96)
!117 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !102, file: !103, line: 104, size: 64, elements: !118)
!118 = !{!119, !125}
!119 = !DIDerivedType(tag: DW_TAG_member, scope: !117, file: !103, line: 104, baseType: !120, size: 64)
!120 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !117, file: !103, line: 104, size: 64, elements: !121)
!121 = !{!122, !124}
!122 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !120, file: !103, line: 104, baseType: !123, size: 32)
!123 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be32", file: !99, line: 27, baseType: !62)
!124 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !120, file: !103, line: 104, baseType: !123, size: 32, offset: 32)
!125 = !DIDerivedType(tag: DW_TAG_member, name: "addrs", scope: !117, file: !103, line: 104, baseType: !126, size: 64)
!126 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !117, file: !103, line: 104, size: 64, elements: !127)
!127 = !{!128, !129}
!128 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !126, file: !103, line: 104, baseType: !123, size: 32)
!129 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !126, file: !103, line: 104, baseType: !123, size: 32, offset: 32)
!130 = !DILocalVariable(name: "nh", scope: !71, file: !3, line: 131, type: !131)
!131 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "hdr_cursor", file: !3, line: 17, size: 64, elements: !132)
!132 = !{!133}
!133 = !DIDerivedType(tag: DW_TAG_member, name: "pos", scope: !131, file: !3, line: 18, baseType: !46, size: 64)
!134 = !DILocalVariable(name: "nh_type", scope: !71, file: !3, line: 132, type: !58)
!135 = !DILocalVariable(name: "____fmt", scope: !136, file: !3, line: 151, type: !139)
!136 = distinct !DILexicalBlock(scope: !137, file: !3, line: 151, column: 3)
!137 = distinct !DILexicalBlock(scope: !138, file: !3, line: 150, column: 28)
!138 = distinct !DILexicalBlock(scope: !71, file: !3, line: 150, column: 5)
!139 = !DICompositeType(tag: DW_TAG_array_type, baseType: !61, size: 216, elements: !140)
!140 = !{!141}
!141 = !DISubrange(count: 27)
!142 = !DILocalVariable(name: "____fmt", scope: !143, file: !3, line: 155, type: !144)
!143 = distinct !DILexicalBlock(scope: !71, file: !3, line: 155, column: 2)
!144 = !DICompositeType(tag: DW_TAG_array_type, baseType: !61, size: 176, elements: !145)
!145 = !{!146}
!146 = !DISubrange(count: 22)
!147 = !DILocation(line: 0, scope: !71)
!148 = !DILocation(line: 118, column: 38, scope: !71)
!149 = !{!150, !151, i64 4}
!150 = !{!"xdp_md", !151, i64 0, !151, i64 4, !151, i64 8, !151, i64 12, !151, i64 16}
!151 = !{!"int", !152, i64 0}
!152 = !{!"omnipotent char", !153, i64 0}
!153 = !{!"Simple C/C++ TBAA"}
!154 = !DILocation(line: 118, column: 27, scope: !71)
!155 = !DILocation(line: 118, column: 19, scope: !71)
!156 = !DILocation(line: 119, column: 34, scope: !71)
!157 = !{!150, !151, i64 0}
!158 = !DILocation(line: 119, column: 23, scope: !71)
!159 = !DILocation(line: 119, column: 15, scope: !71)
!160 = !DILocalVariable(name: "nh", arg: 1, scope: !161, file: !3, line: 54, type: !164)
!161 = distinct !DISubprogram(name: "parse_VLAN", scope: !3, file: !3, line: 54, type: !162, scopeLine: 57, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !166)
!162 = !DISubroutineType(types: !163)
!163 = !{!58, !164, !46, !165}
!164 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !131, size: 64)
!165 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !87, size: 64)
!166 = !{!160, !167, !168, !169, !170, !176, !177, !178}
!167 = !DILocalVariable(name: "data_end", arg: 2, scope: !161, file: !3, line: 55, type: !46)
!168 = !DILocalVariable(name: "ethhdr", arg: 3, scope: !161, file: !3, line: 56, type: !165)
!169 = !DILocalVariable(name: "eth", scope: !161, file: !3, line: 58, type: !87)
!170 = !DILocalVariable(name: "vlh", scope: !161, file: !3, line: 59, type: !171)
!171 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !172, size: 64)
!172 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vlan_hdr", file: !3, line: 44, size: 32, elements: !173)
!173 = !{!174, !175}
!174 = !DIDerivedType(tag: DW_TAG_member, name: "h_vlan_TCI", scope: !172, file: !3, line: 45, baseType: !98, size: 16)
!175 = !DIDerivedType(tag: DW_TAG_member, name: "h_vlan_encapsulated_proto", scope: !172, file: !3, line: 46, baseType: !98, size: 16, offset: 16)
!176 = !DILocalVariable(name: "h_proto", scope: !161, file: !3, line: 60, type: !48)
!177 = !DILocalVariable(name: "i", scope: !161, file: !3, line: 61, type: !58)
!178 = !DILocalVariable(name: "hdrsize", scope: !161, file: !3, line: 63, type: !58)
!179 = !DILocation(line: 0, scope: !161, inlinedAt: !180)
!180 = distinct !DILocation(line: 144, column: 12, scope: !71)
!181 = !DILocation(line: 64, column: 13, scope: !182, inlinedAt: !180)
!182 = distinct !DILexicalBlock(scope: !161, file: !3, line: 64, column: 5)
!183 = !DILocation(line: 64, column: 23, scope: !182, inlinedAt: !180)
!184 = !DILocation(line: 64, column: 5, scope: !161, inlinedAt: !180)
!185 = !DILocation(line: 71, column: 17, scope: !161, inlinedAt: !180)
!186 = !{!187, !187, i64 0}
!187 = !{!"short", !152, i64 0}
!188 = !DILocalVariable(name: "h_proto", arg: 1, scope: !189, file: !3, line: 49, type: !48)
!189 = distinct !DISubprogram(name: "proto_is_vlan", scope: !3, file: !3, line: 49, type: !190, scopeLine: 50, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !192)
!190 = !DISubroutineType(types: !191)
!191 = !{!58, !48}
!192 = !{!188}
!193 = !DILocation(line: 0, scope: !189, inlinedAt: !194)
!194 = distinct !DILocation(line: 75, column: 7, scope: !195, inlinedAt: !180)
!195 = distinct !DILexicalBlock(scope: !196, file: !3, line: 75, column: 6)
!196 = distinct !DILexicalBlock(scope: !197, file: !3, line: 74, column: 36)
!197 = distinct !DILexicalBlock(scope: !198, file: !3, line: 74, column: 2)
!198 = distinct !DILexicalBlock(scope: !161, file: !3, line: 74, column: 2)
!199 = !DILocation(line: 51, column: 20, scope: !189, inlinedAt: !194)
!200 = !DILocation(line: 51, column: 46, scope: !189, inlinedAt: !194)
!201 = !DILocation(line: 75, column: 7, scope: !195, inlinedAt: !180)
!202 = !DILocation(line: 75, column: 6, scope: !196, inlinedAt: !180)
!203 = !DILocation(line: 79, column: 18, scope: !196, inlinedAt: !180)
!204 = !DILocalVariable(name: "nh", arg: 1, scope: !205, file: !3, line: 88, type: !164)
!205 = distinct !DISubprogram(name: "parse_ipv4hdr", scope: !3, file: !3, line: 88, type: !206, scopeLine: 91, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !209)
!206 = !DISubroutineType(types: !207)
!207 = !{!58, !164, !46, !208}
!208 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !101, size: 64)
!209 = !{!204, !210, !211, !212, !213}
!210 = !DILocalVariable(name: "data_end", arg: 2, scope: !205, file: !3, line: 89, type: !46)
!211 = !DILocalVariable(name: "iphdr", arg: 3, scope: !205, file: !3, line: 90, type: !208)
!212 = !DILocalVariable(name: "iph", scope: !205, file: !3, line: 92, type: !101)
!213 = !DILocalVariable(name: "hdrsize", scope: !205, file: !3, line: 93, type: !58)
!214 = !DILocation(line: 0, scope: !205, inlinedAt: !215)
!215 = distinct !DILocation(line: 148, column: 12, scope: !71)
!216 = !DILocation(line: 95, column: 10, scope: !217, inlinedAt: !215)
!217 = distinct !DILexicalBlock(scope: !205, file: !3, line: 95, column: 6)
!218 = !DILocation(line: 95, column: 14, scope: !217, inlinedAt: !215)
!219 = !DILocation(line: 95, column: 6, scope: !205, inlinedAt: !215)
!220 = !DILocation(line: 98, column: 17, scope: !205, inlinedAt: !215)
!221 = !DILocation(line: 98, column: 21, scope: !205, inlinedAt: !215)
!222 = !DILocation(line: 101, column: 13, scope: !223, inlinedAt: !215)
!223 = distinct !DILexicalBlock(scope: !205, file: !3, line: 101, column: 5)
!224 = !DILocation(line: 101, column: 5, scope: !205, inlinedAt: !215)
!225 = !DILocation(line: 105, column: 14, scope: !226, inlinedAt: !215)
!226 = distinct !DILexicalBlock(scope: !205, file: !3, line: 105, column: 6)
!227 = !DILocation(line: 105, column: 24, scope: !226, inlinedAt: !215)
!228 = !DILocation(line: 105, column: 6, scope: !205, inlinedAt: !215)
!229 = !DILocation(line: 111, column: 14, scope: !205, inlinedAt: !215)
!230 = !{!231, !152, i64 9}
!231 = !{!"iphdr", !152, i64 0, !152, i64 0, !152, i64 1, !187, i64 2, !187, i64 4, !187, i64 6, !152, i64 8, !152, i64 9, !187, i64 10, !152, i64 12}
!232 = !DILocation(line: 150, column: 13, scope: !138)
!233 = !DILocation(line: 150, column: 5, scope: !71)
!234 = !DILocation(line: 151, column: 3, scope: !136)
!235 = !DILocation(line: 151, column: 3, scope: !137)
!236 = !DILocation(line: 152, column: 3, scope: !137)
!237 = !DILocation(line: 155, column: 2, scope: !143)
!238 = !DILocation(line: 155, column: 2, scope: !71)
!239 = !DILocation(line: 156, column: 2, scope: !71)
!240 = !DILocation(line: 157, column: 1, scope: !71)
