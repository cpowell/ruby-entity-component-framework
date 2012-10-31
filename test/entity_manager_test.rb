##
# Copyright 2012, Prylis Incorporated.
#
# This file is part of The Ruby Entity-Component Framework.
#
# The Ruby Entity-Component Framework is free software: you can redistribute it
# and/or modify it under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# The Ruby Entity-Component Framework is distributed in the hope that it will be
# useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser
# General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License along
# with The Ruby Entity-Component Framework.  If not, see
# <http://www.gnu.org/licenses/>.

gem 'minitest'
require 'minitest/autorun'
require 'purdytest'

require "lib/ruby/entity_manager"
require "lib/ruby/components/component"

class TestEntityManager < MiniTest::Unit::TestCase
  def setup
    @em = EntityManager.new(nil)
    @comp = Component.new
  end

  def test_initialization_is_sane
    assert_equal([], @em.all_entities)
  end
  
  def test_create_entity
    id=@em.create_basic_entity
    refute_nil(id)
    refute_equal([], @em.all_entities)
    assert_equal(1, @em.all_entities.size)
  end

  def test_create_tagged_entity
    id=@em.create_tagged_entity('blah')
    refute_nil(id)
    refute_equal([], @em.all_entities)
    assert_equal(1, @em.all_entities.size)
    assert_equal('blah', @em.get_entity_tag(id))
  end

  def test_create_tagged_entity_should_disallow_dash
    begin
      id=@em.create_tagged_entity('-')
      flunk "Should not have gotten here"
    rescue ArgumentError => e
      # nop
    end
  end

  def test_create_tagged_entity_should_barf_on_missing_tag
    begin
      id=@em.create_tagged_entity
      flunk "Should not have gotten here"
    rescue ArgumentError => e
      # nop
    end
  end

  # def test_set_entity_tag_should_barf_on_missing_args
  #   begin
  #     id=@em.set_entity_tag(nil, 'tag')
  #     flunk "Should not have gotten here"
  #   rescue ArgumentError => e
  #     # nop
  #   end
  # end

  # def test_change_tag_of_entity
  #   id=@em.create_tagged_entity('blah')
  #   assert_equal('blah', @em.get_entity_tag(id))
  #   @em.set_entity_tag(id, 'foobar')  
  #   assert_equal('foobar', @em.get_entity_tag(id))
  # end

  # def test_get_entity_tag_should_barf_on_missing_args
  #   id=@em.create_tagged_entity('blah')
  #   begin
  #     @em.set_entity_tag(id, nil)
  #     flunk "Should not have gotten here"
  #   rescue ArgumentError => e
  #     # nop
  #   end
  # end

  def test_list_of_known_entities
    id1=@em.create_tagged_entity('blah')
    id2=@em.create_tagged_entity('foobar')
    assert_equal([id1,id2], @em.all_entities)
  end

  def test_get_all_entities_with_tag
    id1=@em.create_tagged_entity('asteroid')
    id2=@em.create_tagged_entity('asteroid')
    id3=@em.create_tagged_entity('ship')
    id4=@em.create_tagged_entity('base')
    assert_equal([id1, id2], @em.get_all_entities_with_tag('asteroid'))
  end

  def test_kill_entity_should_barf_on_missing_args
    begin
      @em.kill_entity(nil)
      flunk "Should not have gotten here"
    rescue ArgumentError => e
      # nop
    end
  end

  def test_kill_entity_should_return_false_on_no_such_entity
    result=@em.kill_entity('uuid that does not exist')
    assert_equal(false, result)
  end

  def test_kill_entity_should_work
    id1=@em.create_tagged_entity('asteroid')
    id2=@em.create_tagged_entity('asteroid')
    id3=@em.create_tagged_entity('ship')
    assert_equal(3, @em.all_entities.size)
    assert_equal([id1, id2], @em.get_all_entities_with_tag('asteroid'))
    assert_equal('asteroid', @em.get_entity_tag(id1))

    result=@em.kill_entity(id1)
    assert_equal(2, @em.all_entities.size)
    assert_equal(true, result)
    assert_equal([id2], @em.get_all_entities_with_tag('asteroid'))
    assert_equal(nil, @em.get_entity_tag(id1))
  end

  def test_add_entity_component_should_barf_on_bad_args
    id=@em.create_tagged_entity('blah')
    begin
      @em.add_entity_component(id, nil)
      flunk "Should not have gotten here"
    rescue ArgumentError => e
      # nop
    end

    begin
      @em.add_entity_component(nil, @comp)
      flunk "Should not have gotten here"
    rescue ArgumentError => e
      # nop
    end
  end

  def test_add_entity_component_should_disallow_component_duplication
    id=@em.create_tagged_entity('blah')
    @em.add_entity_component(id, @comp)
    assert_equal(1, @em.get_all_components_on_entity(id).size)

    @em.add_entity_component(id, @comp)
    assert_equal(1, @em.get_all_components_on_entity(id).size)
  end

  def test_add_entity_component_and_test_for_its_existence
    id=@em.create_tagged_entity('blah')
    @em.add_entity_component(id, @comp)

    assert_equal(true, @em.entity_has_component(id, @comp))

    assert_equal(@comp, @em.get_all_components_on_entity(id)[0])

    assert_equal(@comp, @em.get_entity_component_of_type(id, Component))
  end

  def test_add_and_remove_entity_component
    id=@em.create_tagged_entity('blah')
    @em.add_entity_component(id, @comp)

    assert(@em.entity_has_component(id,@comp))
    assert(@em.entity_has_component_of_type(id,Component))
    assert_equal(1, @em.get_all_components_on_entity(id).size)

    @em.remove_entity_component(id, @comp)

    assert_equal(0, @em.get_all_components_on_entity(id).size)

    refute(@em.entity_has_component(id,@comp))
    refute(@em.entity_has_component_of_type(id,Component))
  end

  def test_get_component_of_type
    id=@em.create_tagged_entity('blah')
    @em.add_entity_component(id, @comp)

    assert(@em.entity_has_component(id,@comp))
    assert_equal(1, @em.get_all_components_on_entity(id).size)

    comp = @em.get_entity_component_of_type(id, Component)
    assert_equal(@comp, comp)
  end

  def test_get_all_entities_with_components_of_type_should_barf_on_bad_argument
    begin
      @em.get_all_entities_with_components_of_type(nil)
      flunk "Should not have gotten here"
    rescue ArgumentError => e
      # nop
    end
  end

  def test_get_all_entities_with_components_of_type
    id1=@em.create_tagged_entity('foo')
    id2=@em.create_tagged_entity('bar')
    id3=@em.create_tagged_entity('baz')

    @em.add_entity_component(id1, @comp)
    @em.add_entity_component(id3, @comp)

    @comp2="string component"
    @em.add_entity_component(id2, @comp2)
    @em.add_entity_component(id3, @comp2)

    @comp3=12345
    @em.add_entity_component(id1, @comp3)
    @em.add_entity_component(id2, @comp3)

    entities = @em.get_all_entities_with_components_of_type([@comp.class])
    assert_equal([id1,id3], entities)

    entities = @em.get_all_entities_with_components_of_type([@comp2.class])
    assert_equal([id2,id3], entities)

    entities = @em.get_all_entities_with_components_of_type([@comp3.class])
    assert_equal([id1,id2], entities)

    entities = @em.get_all_entities_with_components_of_type([@comp2.class, @comp.class, @comp3.class])
    assert_equal([], entities)

    entities = @em.get_all_entities_with_components_of_type([@comp2.class, @comp3.class])
    assert_equal([id2], entities)

    entities = @em.get_all_entities_with_components_of_type([@comp.class, @comp3.class])
    assert_equal([id1], entities)
  end
end
