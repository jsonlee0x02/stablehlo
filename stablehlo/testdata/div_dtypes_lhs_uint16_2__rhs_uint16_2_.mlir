// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<2xui16>, tensor<2xui16>)
    %1 = call @expected() : () -> tensor<2xui16>
    %2 = stablehlo.divide %0#0, %0#1 : tensor<2xui16>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<2xui16>, tensor<2xui16>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<2xui16>, tensor<2xui16>) {
    %0 = stablehlo.constant dense<[3, 2]> : tensor<2xui16>
    %1 = stablehlo.constant dense<[1, 4]> : tensor<2xui16>
    return %0, %1 : tensor<2xui16>, tensor<2xui16>
  }
  func.func private @expected() -> tensor<2xui16> {
    %0 = stablehlo.constant dense<[3, 0]> : tensor<2xui16>
    return %0 : tensor<2xui16>
  }
}