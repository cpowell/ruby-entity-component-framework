require "test/unit"
require "lib/lunar_lander/entity_manager"
require "lib/lunar_lander/components/component"

class EntityManager_test < Test::Unit::TestCase
  def setup
    @em = EntityManager.new(nil)
    @comp = Component.new
  end

  def test_initialization_is_sane
    assert_equal([], @em.entities)
  end
  
  def test_create_entity
    id=@em.create_basic_entity
    assert_not_nil(id)
    assert_not_equal([], @em.entities)
    assert_equal(1, @em.entities.size)
  end

  def test_create_named_entity
    id=@em.create_named_entity('blah')
    assert_not_nil(id)
    assert_not_equal([], @em.entities)
    assert_equal(1, @em.entities.size)
    assert_equal('blah', @em.get_entity_name(id))
  end

  def test_change_name_of_entity
    id=@em.create_named_entity('blah')
    assert_equal('blah', @em.get_entity_name(id))
    @em.set_entity_name(id, 'foobar')  
    assert_equal('foobar', @em.get_entity_name(id))
  end

  def test_entities
    id1=@em.create_named_entity('blah')
    id2=@em.create_named_entity('foobar')
    assert_equal([id1,id2], @em.entities)
  end

  def test_kill_entity
    id1=@em.create_named_entity('blah')
    id2=@em.create_named_entity('foobar')
    assert_equal(2, @em.entities.size)

    @em.kill_entity(id1)

    assert_equal(1, @em.entities.size)
  end

  def test_add_entity_component_and_test_for_its_existence
    id=@em.create_named_entity('blah')
    @em.add_entity_component(id, @comp)

    assert_equal(true, @em.entity_has_component(id, @comp))

    assert_equal(@comp, @em.get_all_components_on_entity(id)[0])

    assert_equal(@comp, @em.get_entity_component_of_type(id, Component))
  end

  def test_add_and_remove_entity_component
    id=@em.create_named_entity('blah')
    @em.add_entity_component(id, @comp)

    assert_equal(true, @em.entity_has_component(id,@comp))

    @em.remove_entity_component(id, @comp)

    assert_equal(false, @em.entity_has_component(id,@comp))
  end
end
