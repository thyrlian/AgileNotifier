class Module
  def backup_const(name)
    redef_const(:TEMP_BACKUP, const_get(name))
  end

  def restore_const(name)
    redef_const(name, const_get(:TEMP_BACKUP))
    remove_const(:TEMP_BACKUP)
  end

  def redef_const(name, value)
    remove_const(name) if const_defined?(name)
    const_set(name, value)
  end

  def stub_const_and_test(const_name, const_value, &test_blk)
    backup_const(const_name)
    redef_const(const_name, const_value)
    test_blk.call
    restore_const(const_name)
  end
end