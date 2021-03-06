#
# $Id: parser.rb,v 1.7 2005/11/20 17:31:32 aamine Exp $
#
# Copyright (c) 1999-2005 Minero Aoki
#
# This program is free software.
# You can distribute/modify this program under the same terms of ruby.
#
# As a special exception, when this code is copied by Racc
# into a Racc output file, you may use that output file
# without restriction.
#
# Hacked by Ben Matasar <ben@dabbledb.com> to work with MagLev.
# 
# copied from lib and code moved to module MagRp for the internal parser

module MagRp
  class ParseError < StandardError; end
end

module MagRp # {

  # deleted Racc_No_Extentions, not used

  class Parser # [

    PrintRaccArrayInfo = false

    Racc_Runtime_Version = '1.4.5'
    Racc_Runtime_Revision = '$Revision: 1.7 $'.split[1]

    Racc_Runtime_Core_Version_R = '1.4.5'
    Racc_Runtime_Core_Revision_R = '$Revision: 1.7 $'.split[1]
    Racc_Main_Parsing_Routine    = :_racc_do_parse_rb
    Racc_YY_Parse_Method         = :_racc_yyparse_rb
    Racc_Runtime_Core_Version    = Racc_Runtime_Core_Version_R
    Racc_Runtime_Core_Revision   = Racc_Runtime_Core_Revision_R
    Racc_Runtime_Type            = 'ruby'

    def Parser.racc_runtime_type
      Racc_Runtime_Type
    end

    def _bind_instvars
      # ensures instvars are ram_oops , returns self
      # Used to initialze a transient copy of MagTemplate
      @mydebug = MagRp::debug > 1
      @racc_debug_out = @racc_debug_out
      @action_table = TransientShortArray._with_shorts(@action_table).freeze
      @action_check = TransientShortArray._with_shorts(@action_check).freeze
      @action_default = @action_default
      @action_pointer = @action_pointer
      @goto_table = TransientShortArray._with_shorts(@goto_table).freeze
      @goto_check = TransientShortArray._with_shorts(@goto_check).freeze
      @goto_default = @goto_default
      @goto_pointer = @goto_pointer
      rt = @reduce_table.dup
      len = rt.size
      idx = 0
      while idx < len
        ofs = idx + 2
        rt[ofs] = rt[ofs] # fault in symbols
        idx += 3
      end
      rt.__set_nostubbing
      rt.freeze
      @reduce_table = rt
      @token_table = @token_table
      @lexer = nil
      @env = nil 
      @syntax_err_count = 0
      self.__set_nostubbing
      self
    end

    def _racc_init_sysvars
      # initialize the instance variables which change during parsing
      @racc_state  = [0]
      @racc_tstack = []
      @racc_vstack = []

      @racc_t = nil
      @racc_val = nil

      @racc_read_next = true

      @racc_user_yyerror = false
      @racc_error_status = 0
    end

    def env
      @env
    end

    # remaining code is in files racc_init_parser.rb and racc_parser.rb 

  end # ]

  class RubyParser < Parser  # [

    VERSION = '2.0.2'

    def _bind_instvars
      # Used to initialze a transient copy of MagTemplate, returns receiver
      @in_single = 0
      @in_def = false
      super
    end

    def _install_wordlist(hash)
      @lexer_wordlist = hash
    end

    def _wordlist
      @lexer_wordlist
    end

    def file_name
      @file_name
    end
    def source_string
      @source_string
    end

    InvalidAssignableLhs = IdentitySet.with_all(
       [ :self , :nil , :true , :false , :"__LINE__" , :"__FILE__" ] )

    # replicate some constants from Regexp so they can be
    # resolved at boot compile time in extras.rb
    IGNORECASE = Regexp::IGNORECASE
    MULTILINE = Regexp::MULTILINE
    EXTENDED = Regexp::EXTENDED
    #  defined?  not supported during boostrap
    #  assume Regexp::ONCE not defined in 1.8.6
    #if defined?( Regexp::ONCE)
    #  ONCE = Regexp::ONCE
    #  ENC_NONE = Regexp::ENC_NONE
    #  ENC_EUC = Regexp::ENC_EUC
    #  ENC_SJIS = Regexp::ENC_SJIS
    #  ENC_UTF8 = Regexp::ENC_UTF8
    #else
      ONCE     = 0 # 16 # ?
      ENC_NONE = /x/n.options
      ENC_EUC  = /x/e.options
      ENC_SJIS = /x/s.options
      ENC_UTF8 = /x/u.options
    #end

    # replicate some constants from the lexer so they can be
    #  bound at boot compile time in ruby_parser.rb
    Expr_beg = RubyLexer::Expr_beg
    Expr_end = RubyLexer::Expr_end
    Expr_fname = RubyLexer::Expr_fname
    Expr_endArg = RubyLexer::Expr_endArg

  end # ]
  RubyParser.__freeze_constants

  class Keyword # [
    def self.create_transient_wordlist
      # create a StringKeyValueDictionary from WORDLIST, 
      # The dictionary, which is not committed,
      #  will have memory pointer references to all keys and values
      # Use a StringKeyValueDictionary instead of a Hash
      #  because it has a C primitive for at() .
      list = WORDLIST
      h = StringKeyValueDictionary.__new( list.size )
      list.each { | arr |
	k = arr[0]
	v = arr[1].dup
	v_siz = v.size
	for i in 0..v_siz-1 do
	  v[i] = v[i] # make ref a RamOop
	end
	h.at_put(k, v)
      }
      h.freeze
      h
    end
  end # ]

end # }

