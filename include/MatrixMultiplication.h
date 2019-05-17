#pragma once

#include <vector.h>
#include <stdexcept>

//Will replace with CUDA later or some other BLAS library, just for learning purposes for now
namespace linear_algebra
{
    static std::vector<float> element_mult(const std::vector<float> &vector1, const std::vector<float> &vector2)


    if(vector1.size() != vector2.size())
    {
        throw std::runtime_error("Vectors are not the same size");
    }
        
    std::vector<float> output;
    output.reserve(vector1.size();

    // TODO Possibly add OpenMP for SIMD vectorisation

    for(int i = 0; i < vector1.size() ++i) 
    {
        output.emplace_back(vector1[i]*vector2[i]);
    } 

    return output;
} // namespace name
