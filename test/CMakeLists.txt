enable_testing()

include_directories("${source_dir}/googletest/include")

add_executable(runPerceptronUnitTests Test_Perceptron.cpp  main.cpp)

target_link_libraries(runPerceptronUnitTests libgtest libgmock NN_Perceptron)

add_test(PerceptronUnitTests runPerceptronUnitTests)

