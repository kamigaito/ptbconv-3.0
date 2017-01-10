def show_version(_os=$stdout, _exit=true)
  _os.puts "ptbconv-%s: Converter for Penn treebank corpus." % $version
  exit if _exit
end

def show_help(_os=$stdout)
  show_version(_os, false)
  _os.puts "usage: ptbconv -[options] < penn_treebank.mrg"
  _os.puts "\t-v : show version."
  _os.puts "\t-h : show help."
  _os.puts "\t-g : enable gaps."
  _os.puts "\t-V : show ASCII trees."
  _os.puts "\t-t : trace mode for debugging."
  _os.puts "\t-B : show parses as bracket froms"
  _os.puts "\t-C : extracting CFG rules."
  _os.puts "\t-D : converting phrase structures into dependency forms."
  _os.puts "\t-H : show head rules."
  _os.puts "\t-T : show explanations of defined tags."
  _os.puts "\t-N i: converting the i-th sentence."
  _os.puts "\t-R file: re-define head rules specified in the file."
  exit
end

def to_dependency(_tree) 
  _terminals = Hash.new

  _root = nil 
  _tree.post_order do |_node|
    next if _node.none_terminal?

    unless _terminals[_node.offset]
      _terminals[_node.offset] = DependencyStructure.new(_node.word, _node.part_of_speech, _node.offset + $index_of_first_word)  
    end

    _target = _node
    _parent = _target.parent

    _head = _parent.head_child

    while _head === _target
      _target = _parent
      _parent = _target.parent
      next if _target.root? || _target.top?  
      _head   = _parent.head_child
    end

    _head = _head.head_terminal

    if _head === _node
      _root = _terminals[_node.offset]
      next 
    end

    unless _terminals[_head.offset]
      _terminals[_head.offset] = DependencyStructure.new(_head.word, _head.part_of_speech, _head.offset + $index_of_first_word)  
    end
    _terminals[_head.offset].add(_terminals[_node.offset])
  end
  return _root 
end

def show_head_rules(_os=$stdout)
  _os.puts "<Head Rules>"
  _os.puts "NoneTerminal  Direction  Priority"
  _os.puts
  NaturalLanguage::Corpus::PennTreebank::PhrasalCategory.each_defined_tag do |_tag|
    _os.puts _tag.head_rule
  end
  _os.puts
end

def show_explanations_of_each_tag(_os=$stdout)
  _os.puts "* Phrasal Categories"
  _os.puts
  NaturalLanguage::Corpus::PennTreebank::PhrasalCategory.each_defined_tag do |_tag|
    _os.puts "%5s : %s" % [_tag::TAG, _tag::EXPLANATION]
  end
  _os.puts
  _os.puts "* Part of Speech tags"
  NaturalLanguage::Corpus::PennTreebank::PartOfSpeech.each_defined_tag do |_tag|
    _os.puts "%5s : %s" % [_tag::TAG, _tag::EXPLANATION]
  end
  _os.puts
end 

def show_cfg(_tree, _os=$stdout)
  _tree.pre_order do |_node|
    next if _node.terminal?
    _left, _right = _node.to_cfg_rule
    _os.print "%s ->" % _left
    _right.each do |r|
      t = r.to_s
      t = r.phrasal_category if r.none_terminal?
      _os.print " %s" % t
    end
    _os.puts 
  end
  _os.puts
end

def reduce_unary(_tree)

  return _tree if $OPT_g
  _tree.reduce_unary
  return _tree
end

def show_bracket(_tree, _os=$stdout)
  _os.puts _tree.bracketing 
end
def show_dependencies(_tree, _os=$stdout)
  _nodes = []
  _tree.pre_order do |_node| 
    _nodes << _node
  end

  _nodes.sort{|x,y| x.offset <=> y.offset}.each do |_node|
    i = -1
    i = _node.parent.offset unless (_node.top? || _node.root?)
    _os.puts "%s\t%s\t%s" % [_node.word, _node.part_of_speech, i]
  end
  _os.puts
end

def show_tree_path(_tree, _os=$stdout)
  _nodes = []
  _tree.pre_order do |_node|
    _nodes << _node if _node.terminal?
  end

  _nodes.sort{|x,y| x.offset <=> y.offset}.each do |_node|
    x = _node
    y = _node.parent
    _os.print "#{x.word}\t#{x.part_of_speech}"

    # while ! (x.top? || x.root?)
    while ! (x.root?)
      
      # _os.print "\t#{x.unlexicalize}" unless x.terminal?
      _os.print "\t#{y.unlexicalize}"

      #puts "\tx=#{x} y=#{y} y.head=#{y.head_terminal}"
      break if x.object_id != y.head_child.object_id
      x = x.parent 
      y = y.parent
    end
    _os.print "\tTOP" if x.root?
    _os.puts ""
  end
  _os.puts 

end
