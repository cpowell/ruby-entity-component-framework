##
# Copyright 2012, Prylis Incorporated.
#
# This file is part of The Ruby Entity-Component Framework.
# https://github.com/cpowell/ruby-entity-component-framework
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the framework.

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
    assert_equal('blah', @em.get_tag(id))
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

  # def test_set_tag_should_barf_on_missing_args
  #   begin
  #     id=@em.set_tag(nil, 'tag')
  #     flunk "Should not have gotten here"
  #   rescue ArgumentError => e
  #     # nop
  #   end
  # end

  # def test_change_tag_of_entity
  #   id=@em.create_tagged_entity('blah')
  #   assert_equal('blah', @em.get_tag(id))
  #   @em.set_tag(id, 'foobar')  
  #   assert_equal('foobar', @em.get_tag(id))
  # end

  # def test_get_tag_should_barf_on_missing_args
  #   id=@em.create_tagged_entity('blah')
  #   begin
  #     @em.set_tag(id, nil)
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
    assert_equal('asteroid', @em.get_tag(id1))

    result=@em.kill_entity(id1)
    assert_equal(2, @em.all_entities.size)
    assert_equal(true, result)
    assert_equal([id2], @em.get_all_entities_with_tag('asteroid'))
    assert_equal(nil, @em.get_tag(id1))
  end

  def test_add_component_should_barf_on_bad_args
    id=@em.create_tagged_entity('blah')
    begin
      @em.add_component(id, nil)
      flunk "Should not have gotten here"
    rescue ArgumentError => e
      # nop
    end

    begin
      @em.add_component(nil, @comp)
      flunk "Should not have gotten here"
    rescue ArgumentError => e
      # nop
    end
  end

  def test_add_component_should_disallow_component_duplication
    id=@em.create_tagged_entity('blah')
    @em.add_component(id, @comp)
    assert_equal(1, @em.get_all_components(id).size)

    @em.add_component(id, @comp)
    assert_equal(1, @em.get_all_components(id).size)
  end

  def test_add_component_and_test_for_its_existence
    id=@em.create_tagged_entity('blah')
    @em.add_component(id, @comp)

    assert_equal(true, @em.has_component(id, @comp))

    assert_equal(@comp, @em.get_all_components(id)[0])

    assert_equal(@comp, @em.get_component_of_type(id, Component))
  end

  def test_add_and_remove_component
    id=@em.create_tagged_entity('blah')
    @em.add_component(id, @comp)

    assert(@em.has_component(id,@comp))
    assert(@em.has_component_of_type(id,Component))
    assert_equal(1, @em.get_all_components(id).size)

    @em.remove_component(id, @comp)

    assert_equal(0, @em.get_all_components(id).size)

    refute(@em.has_component(id,@comp))
    refute(@em.has_component_of_type(id,Component))
  end

  def test_get_component_of_type
    id=@em.create_tagged_entity('blah')
    @em.add_component(id, @comp)

    assert(@em.has_component(id,@comp))
    assert_equal(1, @em.get_all_components(id).size)

    comp = @em.get_component_of_type(id, Component)
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

    @em.add_component(id1, @comp)
    @em.add_component(id3, @comp)

    @comp2="string component"
    @em.add_component(id2, @comp2)
    @em.add_component(id3, @comp2)

    @comp3=12345
    @em.add_component(id1, @comp3)
    @em.add_component(id2, @comp3)

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
