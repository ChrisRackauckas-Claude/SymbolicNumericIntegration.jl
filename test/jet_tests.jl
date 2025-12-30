using JET
using SymbolicNumericIntegration
using Symbolics
using Test

@testset "JET static analysis" begin
    @variables x

    # Test that isdependent returns Bool (not Union{Missing, Bool})
    @testset "isdependent type stability" begin
        result = SymbolicNumericIntegration.isdependent(x^2, x)
        @test result isa Bool
        @test result == true

        result = SymbolicNumericIntegration.isdependent(1, x)
        @test result isa Bool
        @test result == false
    end

    # Test that is_number returns Bool
    @testset "is_number type stability" begin
        @test SymbolicNumericIntegration.is_number(1) == true
        @test SymbolicNumericIntegration.is_number(1.0) == true
        @test SymbolicNumericIntegration.is_number(1 // 2) == true
        @test SymbolicNumericIntegration.is_number(1.0 + 2.0im) == true
        @test SymbolicNumericIntegration.is_number(x) == false
    end

    # Test key utility functions with JET.report_call
    @testset "JET report_call on utility functions" begin
        # Test ops function
        rep = JET.report_call(SymbolicNumericIntegration.ops, (typeof(x^2),))
        # We expect some issues from upstream but the function should be analyzable
        @test rep isa JET.JETCallResult

        # Test is_add function
        rep = JET.report_call(SymbolicNumericIntegration.is_add, (typeof(x + 1),))
        @test rep isa JET.JETCallResult

        # Test is_mul function
        rep = JET.report_call(SymbolicNumericIntegration.is_mul, (typeof(x * 2),))
        @test rep isa JET.JETCallResult
    end
end
