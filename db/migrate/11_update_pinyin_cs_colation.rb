class UpdatePinyinCsColation < ActiveRecord::Migration
  def up
    execute("ALTER TABLE words MODIFY `pinyin_cs` varchar(255) COLLATE utf8_bin;")
  end

  def down
    execute("ALTER TABLE words MODIFY `pinyin_cs` varchar(255) COLLATE utf8_unicode_ci;")
  end
end
