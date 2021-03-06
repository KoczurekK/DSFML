/*
 * DSFML - The Simple and Fast Multimedia Library for D
 *
 * Copyright (c) 2013 - 2018 Jeremy DeHaan (dehaan.jeremiah@gmail.com)
 *
 * This software is provided 'as-is', without any express or implied warranty.
 * In no event will the authors be held liable for any damages arising from the
 * use of this software.
 *
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 * 1. The origin of this software must not be misrepresented; you must not claim
 * that you wrote the original software. If you use this software in a product,
 * an acknowledgment in the product documentation would be appreciated but is
 * not required.
 *
 * 2. Altered source versions must be plainly marked as such, and must not be
 * misrepresented as being the original software.
 *
 * 3. This notice may not be removed or altered from any source distribution
 *
 *
 * DSFML is based on SFML (Copyright Laurent Gomila)
 */

#ifndef DSFML_CONVERTTRANSFORM_H
#define DSFML_CONVERTTRANSFORM_H

#include <SFML/Graphics/Transform.hpp>

// Convert sf::Transform to float array
inline void createTransform(const sf::Transform& transform, float* converted)
{
    const float* m = transform.getMatrix();
    converted[0] = m[0];
    converted[1] = m[4];
    converted[2] = m[12];
    converted[3] = m[1];
    converted[4] = m[5];
    converted[5] = m[13];
    converted[6] = m[3];
    converted[7] = m[7];
    converted[8] = m[15];
}

// Convert float array to sf::Transform
inline sf::Transform createTransform(const float* transform)
{

    return sf::Transform(transform[0], transform[1], transform[2],
                         transform[3], transform[4], transform[5],
                         transform[6], transform[7], transform[8]);
}

#endif // DSFML_CONVERTTRANSFORM_H
