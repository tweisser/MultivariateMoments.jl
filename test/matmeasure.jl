@testset "MatMeasure" begin
    Mod.@polyvar x y
    @test_throws ArgumentError matmeasure(Measure([1], [x]), [y])
end

# [HL05] Henrion, D. & Lasserre, J-B.
# Detecting Global Optimality and Extracting Solutions of GloptiPoly 2005

@testset "[HL05] Section 2.3" begin
    Mod.@polyvar x y
    ν = AtomicMeasure([x, y], [0.4132, 0.3391, 0.2477], [[1, 2], [2, 2], [2, 3]])
    μ = Measure(ν, [x^4, x^3*y, x^2*y^2, x*y^3, y^4, x^3, x^2*y, x*y^2, y^3, x^2, x*y, y^2, x, y, 1])
    μ = matmeasure(μ, [1, x, y, x^2, x*y, y^2])
    atoms = extractatoms(μ, 1e-4, 1e-14)
    @test isapprox(atoms, ν)
end

@testset "[HL05] Section 3.3.1" begin
    Mod.@polyvar x y z
    U = [1 0 0 0 0 0;
         0 1 0 0 0 0;
         0 0 1 0 0 0;
         2 0 0 0 0 0; # z^2 = 2z
         0 0 0 1 0 0;
         0 2 0 0 0 0; # y^2 = 2y
         0 0 0 0 1 0;
         0 0 0 0 0 1;
         0 0 2 0 0 0] # x^2 = 2x
    # β will be [z, y, x, y*z, x*z, x*y]
    x = monovec([z, y, x, z^2, y*z, y^2, x*z, x*y, x^2])
    # x*β contains x*y*z, x^2*z, x^2*y which are not present so it show fail
    V = MultivariateMoments.build_system(U', x)
    @test iszerodimensional(V)
    sols = [[2.0, 0., 0.], [2.0, 2.0, 0.], [2.0, 2.0, 2.0], [0., 0., 0.]]
    @test length(V) == 4
    for sol in sols
        @test any(v -> isapprox(sol, v, rtol=1e-4), V)
    end
end

#@testset "[HL05] Section 4" begin
#    Mod.@polyvar x y
#    μ = Measure([1/9,     0,     1/9,     0, 1/9,   0,     0,     0,   0, 1/3,   0, 1/3, 0, 0, 1],
#                [x^4, x^3*y, x^2*y^2, x*y^3, y^4, x^3, x^2*y, x*y^2, y^3, x^2, x*y, y^2, x, y, 1])
#    μ = matmeasure(μ, [1, x, y, x^2, x*y, y^2])
#    @show extractatoms(μ, 1e-16, 1e-16)
#end
