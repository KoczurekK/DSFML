/*
DSFML - The Simple and Fast Multimedia Library for D

Copyright (c) 2013 - 2015 Jeremy DeHaan (dehaan.jeremiah@gmail.com)

This software is provided 'as-is', without any express or implied warranty.
In no event will the authors be held liable for any damages arising from the use of this software.

Permission is granted to anyone to use this software for any purpose, including commercial applications,
and to alter it and redistribute it freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software.
If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.

2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.

3. This notice may not be removed or altered from any source distribution
*/

module dsfml.graphics.view;

import dsfml.graphics.rect;
import dsfml.system.vector2;
import dsfml.graphics.transform;

/++
 + 2D camera that defines what region is shown on screen
 +
 + View defines a camera in the 2D scene.
 +
 + This is a very powerful concept: you can scroll, rotate or zoom the entire scene without altering the way that your drawable objects are drawn.
 +
 + A view is composed of a source rectangle, which defines what part of the 2D scene is shown, and a target viewport, which defines where the contents of the source rectangle will be displayed on the render target (window or texture).
 +
 + The viewport allows to map the scene to a custom part of the render target, and can be used for split-screen or for displaying a minimap, for example. If the source rectangle has not the same size as the viewport, its contents will be stretched to fit in.
 +
 + To apply a view, you have to assign it to the render target. Then, every objects drawn in this render target will be affected by the view until you use another view.
 +
 + Authors: Laurent Gomila, Jeremy DeHaan
 + See_Also: http://www.sfml-dev.org/documentation/2.0/classsf_1_1View.php#details
 +/

struct View
{
	this (FloatRect rectangle)
	{
		reset (rectangle);
	}

	this (Vector2f center, Vector2f size)
	{
		m_center = center;
		m_size = size;
	}
	/// The center of the view.
	@property
	{
		Vector2f center(Vector2f newCenter)
		{
			m_center = newCenter;

			m_transformUpdated = false;
			m_invTransformUpdated = false;

			return newCenter;
		}

		Vector2f center() const
		{
			return m_center;
		}
	}

	/// The orientation of the view, in degrees. The default rotation is 0 degrees.
	@property
	{
		float rotation(float newRotation)
		{
			m_rotation = newRotation % 360.0;
			if (m_rotation <0)
				m_rotation += 360.0;

			m_transformUpdated = false;
			m_invTransformUpdated = false;

			return newRotation;
		}
		float rotation() const
		{
			return m_rotation;

		}
	}

	/// The size of the view. The default size is (1, 1).
	@property
	{
		Vector2f size(Vector2f newSize)
		{
			m_size = newSize;
			m_transformUpdated = false;
			m_invTransformUpdated = false;
			return newSize;
		}

		Vector2f size() const
		{
			return m_size;
		}
	}

	/**
	 * The target viewpoirt.
	 *
	 * The viewport is the rectangle into which the contents of the view are displayed, expressed as a factor (between 0 and 1) of the size of the RenderTarget to which the view is applied. For example, a view which takes the left side of the target would be defined with View.setViewport(FloatRect(0, 0, 0.5, 1)). By default, a view has a viewport which covers the entire target.
	 */
	@property
	{
		FloatRect viewport(FloatRect newTarget)
		{
			m_viewport = newTarget;

			return newTarget;
		}
		FloatRect viewport() const
		{
			return m_viewport;
		}
	}

	/**
	 * Move the view relatively to its current position.
	 *
	 * Params:
	 * 		offset	= Move offset
	 */
	void move(Vector2f offset)
	{
		center = m_center + offset;
	}

	/**
	 * Reset the view to the given rectangle.
	 *
	 * Note that this function resets the rotation angle to 0.
	 *
	 * Params:
	 * 		rectangle	= Rectangle defining the zone to display.
	 */
	void reset(FloatRect rectangle)
	{
		m_center.x = rectangle.left + rectangle.width / 2.0;
		m_center.y = rectangle.top + rectangle.height / 2.0;
		m_size.x = rectangle.width;
		m_size.y = rectangle.height;
		m_rotation = 0;

		m_transformUpdated = false;
		m_invTransformUpdated = false;
	}

	/**
	 * Resize the view rectangle relatively to its current size.
	 *
	 * Resizing the view simulates a zoom, as the zone displayed on screen grows or shrinks. factor is a multiplier:
	 * - 1 keeps the size unchanged.
	 * - > 1 makes the view bigger (objects appear smaller).
	 * - < 1 makes the view smaller (objects appear bigger).
	 *
	 * Params:
	 * 		factor	= Zoom factor to apply.
	 */
	void zoom(float factor)
	{
		size = m_size * factor;
	}

	/**
	  Get the projection transform of the view.

	  This function is meant for internal use only.

	  Returns
	      Projection transform defining the view

	  See also
	      getInverseTransform
	*/

	Transform getTransform()
	{
		import std.math;
	    // Recompute the matrix if needed
	    if (!m_transformUpdated)
	    {
	        // Rotation components
	        float angle  = m_rotation * 3.141592654f / 180.f;
	        float cosine = cos(angle);
	        float sine   = sin(angle);
	        float tx     = -m_center.x * cosine - m_center.y * sine + m_center.x;
	        float ty     =  m_center.x * sine - m_center.y * cosine + m_center.y;

	        // Projection components
	        float a =  2.f / m_size.x;
	        float b = -2.f / m_size.y;
	        float c = -a * m_center.x;
	        float d = -b * m_center.y;

	        // Rebuild the projection matrix
	        m_transform = Transform( a * cosine, a * sine,   a * tx + c,
	                                -b * sine,   b * cosine, b * ty + d,
	                                 0.f,        0.f,        1.f);
	        m_transformUpdated = true;
	    }

	    return m_transform;
	}



	/**
	  Get the inverse projection transform of the view.

	  This function is meant for internal use only.

	  Returns
	      Inverse of the projection transform defining the view

	  See also
	      getTransform
	*/

	Transform getInverseTransform()
	{
	    // Recompute the matrix if needed
	    if (!m_invTransformUpdated)
	    {
	        m_inverseTransform = getTransform().getInverse();
	        m_invTransformUpdated = true;
	    }

	    return m_inverseTransform;
	}

	package
	{
		Vector2f m_center = Vector2f(500, 500);
		Vector2f m_size = Vector2f(1000, 1000);
		float m_rotation = 0;
		FloatRect m_viewport = FloatRect(0, 0, 1, 1);
	}
	private
	{
		bool m_transformUpdated;
		bool m_invTransformUpdated;
		Transform m_transform;
		Transform m_invTransform;
	}
}


unittest
{
	version(DSFML_Unittest_Graphics)
	{
		import std.stdio;

		import dsfml.graphics.rendertexture;

		writeln("Unit test for View");

		//the portion of the screen the view is displaying is at position (0,0) with a width of 100 and a height of 100
		auto view = new View(FloatRect(0,0,100,100));

		//the portion of the screen the view is displaying is at position (0,0) and takes up the remaining size of the screen.(expressed as a ratio)
		view.viewport = FloatRect(0,0,1,1);

		auto renderTexture = new RenderTexture();

		renderTexture.create(1000,1000);

		renderTexture.clear();

		//set the view of the renderTexture
		renderTexture.view = view;

		//draw some things using this view

		//get it ready for rendering
		renderTexture.display();





		writeln();
	}
}


