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

/**
 * A vertex is an improved point. It has a position and other extra attributes
 * that will be used for drawing: in DSFML, vertices also have a color and a
 * pair of texture coordinates.
 *
 * The vertex is the building block of drawing. Everything which is visible on
 * screen is made of vertices. They are grouped as 2D primitives (triangles,
 * quads, ...), and these primitives are grouped to create even more complex 2D
 * entities such as sprites, texts, etc.
 *
 * If you use the graphical entities of DSFML (sprite, text, shape) you won't
 * have to deal with vertices directly. But if you want to define your own 2D
 * entities, such as tiled maps or particle systems, using vertices will allow
 * you to get maximum performances.
 *
 * Example:
 * ---
 * // define a 100x100 square, red, with a 10x10 texture mapped on it
 * sf::Vertex vertices[] =
 * [
 *     Vertex(Vector2f(  0,   0), Color.Red, Vector2f( 0,  0)),
 *     Vertex(Vector2f(  0, 100), Color.Red, Vector2f( 0, 10)),
 *     Vertex(Vector2f(100, 100), Color.Red, Vector2f(10, 10)),
 *     Vertex(Vector2f(100,   0), Color.Red, Vector2f(10,  0))
 * ];
 *
 * // draw it
 * window.draw(vertices, 4, PrimitiveType.Quads);
 * ---
 *
 * $(PARA $(B Note): although texture coordinates are supposed to be an integer
 * amount of pixels, their type is float because of some buggy graphics drivers
 * that are not able to process integer coordinates correctly.)
 *
 * See_Also:
 * $(VERTEXARRAY_LINK)
 */
module dsfml.graphics.vertex;

import dsfml.graphics.color;
import dsfml.system.vector2;

/**
 * Define a point with color and texture coordinates.
 */
struct Vertex
{
    /// 2D position of the vertex
    Vector2f position = Vector2f(0,0);
    /// Color of the vertex. Default is White.
    Color color = Color.White;
    /// 2D coordinates of the texture's pixel map to the vertex.
    Vector2f texCoords = Vector2f(0,0);

    /**
     * Construct the vertex from its position
     *
     * The vertex color is white and texture coordinates are (0, 0).
     *
     * Params:
     * thePosition = Vertex position
     */
    this(Vector2f thePosition)
    {
        position = thePosition;
    }

    /**
     * Construct the vertex from its position and color
     *
     * The texture coordinates are (0, 0).
     *
     * Params:
     *  thePosition = Vertex position
     *  theColor    = Vertex color
     */
    this(Vector2f thePosition, Color theColor)
    {
        position = thePosition;
        color = theColor;
    }

    /**
     * Construct the vertex from its position and texture coordinates
     *
     * The vertex color is white.
     *
     * Params:
     *  thePosition  = Vertex position
     *  theTexCoords = Vertex texture coordinates
     */
    this(Vector2f thePosition, Vector2f theTexCoords)
    {
        position = thePosition;
        texCoords = theTexCoords;
    }

    /**
     * Construct the vertex from its position, color and texture coordinates
     *
     * Params:
     *  thePosition  = Vertex position
     *  theColor     = Vertex color
     *  theTexCoords = Vertex texture coordinates
     */
    this(Vector2f thePosition, Color theColor, Vector2f theTexCoords)
    {
        position = thePosition;
        color = theColor;
        texCoords = theTexCoords;
    }
}

unittest
{
    version(DSFML_Unittest_Graphics)
    {
        //not really needed, but implemented for code coverage later.
        import std.stdio;

        writeln("Unit test for Vertex");


        auto vertex = Vertex();

        vertex.position = Vector2f(1,1);

        vertex.color = Color.Blue;

        vertex.texCoords = Vector2f(20,10);

        writeln();
    }
}
