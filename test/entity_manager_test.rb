require "test/unit"
require "lib/lunar_lander/entity_manager"

class EntityManager_test < Test::Unit::TestCase
  def setup
    @em = EntityManager.new(nil)
  end

  def test_initialization_is_sane
    assert_equal([], @em.get_known_entities)
  end
  
  def test_create_entity
    id=@em.create_basic_entity
    assert_not_nil(id)
    assert_not_equal([], @em.get_known_entities)
    assert_equal(1, @em.get_known_entities.size)
  end

  def test_create_named_entity
    id=@em.create_named_entity('blah')
    assert_not_nil(id)
    assert_not_equal([], @em.get_known_entities)
    assert_equal(1, @em.get_known_entities.size)
    assert_equal('blah', @em.get_entity_name(id))
  end

  def test_change_name_of_entity
    id=@em.create_named_entity('blah')
    assert_equal('blah', @em.get_entity_name(id))
    @em.set_entity_name(id, 'foobar')  
    assert_equal('foobar', @em.get_entity_name(id))
  end

  def test_get_known_entities
    id1=@em.create_named_entity('blah')
    id2=@em.create_named_entity('foobar')
    assert_equal([id1,id2], @em.get_known_entities)
  end

  def test_kill_entity
    id1=@em.create_named_entity('blah')
    id2=@em.create_named_entity('foobar')
    assert_equal(2, @em.get_known_entities.size)

    @em.kill_entity(id1)

    assert_equal(1, @em.get_known_entities.size)
  end

  def test_add_component_and_test_for_its_existence
    id=@em.create_named_entity('blah')
    string_component = 'This is a string'
    @em.add_component(id, string_component)

    assert_equal(true, @em.has_component(id,string_component))

    assert_equal(string_component, @em.get_all_components_on_entity(id)[0])

    assert_equal(string_component, @em.get_component(id, String))
  end

  def test_add_and_remove_component
    id=@em.create_named_entity('blah')
    string_component = 'This is a string'
    @em.add_component(id, string_component)

    assert_equal(true, @em.has_component(id,string_component))

    @em.remove_component(id, string_component)

    assert_equal(false, @em.has_component(id,string_component))
  end
end
