@testset "IDM" begin 
    roadway = gen_straight_roadway(1, 500.0)

    models = Dict{Int, DriverModel}()
    models[1] = IntelligentDriverModel(k_spd = 1.0, v_des = 10.0)
    models[2] = IntelligentDriverModel(k_spd = 1.0, v_des = 5.0)

    veh_state = VehicleState(Frenet(roadway[LaneTag(1,1)], 0.0), roadway, 5.)
    veh1 = Vehicle(veh_state, VehicleDef(), 1)
    veh_state = VehicleState(Frenet(roadway[LaneTag(1,1)], 70.0), roadway, 5.)
    veh2 = Vehicle(veh_state, VehicleDef(), 2)

    scene = Scene()
    push!(scene, veh1)
    push!(scene, veh2)

    n_steps = 40
    dt = 0.1
    rec = SceneRecord(n_steps, dt)
    simulate!(rec, scene, roadway, models, n_steps)

    @test isapprox(get_by_id(scene, 2).state.v, models[2].v_des)

    println("There should be a warning here: ")

    # initializing vehicles too close
    veh_state = VehicleState(Frenet(roadway[LaneTag(1,1)], 0.0), roadway, 5.)
    veh1 = Vehicle(veh_state, VehicleDef(), 1)
    veh_state = VehicleState(Frenet(roadway[LaneTag(1,1)], 3.0), roadway, 5.)
    veh2 = Vehicle(veh_state, VehicleDef(), 2)

    scene = Scene()
    push!(scene, veh1)
    push!(scene, veh2)

    rec = SceneRecord(n_steps, dt)
    simulate!(rec, scene, roadway, models, 1)
end