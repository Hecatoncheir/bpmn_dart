(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? module.exports = factory() :
    typeof define === 'function' && define.amd ? define(factory) :
      (global = typeof globalThis !== 'undefined' ? globalThis : global || self, global.BpmnJSBpmnlint = factory());
}(this, (function () {
  'use strict';

  function EditorActions(injector, linting) {
    var editorActions = injector.get('editorActions', false);

    editorActions && editorActions.register({
      toggleLinting: function () {
        linting.toggle();
      }
    });
  }

  EditorActions.$inject = [
    'injector',
    'linting'
  ];

  /**
   * Traverse a moddle tree, depth first from top to bottom
   * and call the passed visitor fn.
   *
   * @param {ModdleElement} element
   * @param {{ enter?: Function; leave?: Function }} options
   */
  var traverse = function traverse(element, options) {

    const enter = options.enter || null;
    const leave = options.leave || null;

    const enterSubTree = enter && enter(element);

    const descriptor = element.$descriptor;

    if (enterSubTree !== false && !descriptor.isGeneric) {

      const containedProperties = descriptor.properties.filter(p => {
        return !p.isAttr && !p.isReference && p.type !== 'String';
      });

      containedProperties.forEach(p => {
        if (p.name in element) {
          const propertyValue = element[p.name];

          if (p.isMany) {
            propertyValue.forEach(child => {
              traverse(child, options);
            });
          } else {
            traverse(propertyValue, options);
          }
        }
      });
    }

    leave && leave(element);
  };

  /**
   * Flatten array, one level deep.
   *
   * @param {Array<?>} arr
   *
   * @return {Array<?>}
   */
  function flatten(arr) {
    return Array.prototype.concat.apply([], arr);
  }

  var nativeToString = Object.prototype.toString;
  var nativeHasOwnProperty = Object.prototype.hasOwnProperty;
  function isUndefined(obj) {
    return obj === undefined;
  }
  function isDefined(obj) {
    return obj !== undefined;
  }
  function isNil(obj) {
    return obj == null;
  }
  function isArray(obj) {
    return nativeToString.call(obj) === '[object Array]';
  }
  function isObject(obj) {
    return nativeToString.call(obj) === '[object Object]';
  }
  function isNumber(obj) {
    return nativeToString.call(obj) === '[object Number]';
  }
  function isFunction(obj) {
    var tag = nativeToString.call(obj);
    return tag === '[object Function]' || tag === '[object AsyncFunction]' || tag === '[object GeneratorFunction]' || tag === '[object AsyncGeneratorFunction]' || tag === '[object Proxy]';
  }
  function isString(obj) {
    return nativeToString.call(obj) === '[object String]';
  }
  /**
   * Ensure collection is an array.
   *
   * @param {Object} obj
   */

  function ensureArray(obj) {
    if (isArray(obj)) {
      return;
    }

    throw new Error('must supply array');
  }
  /**
   * Return true, if target owns a property with the given key.
   *
   * @param {Object} target
   * @param {String} key
   *
   * @return {Boolean}
   */

  function has(target, key) {
    return nativeHasOwnProperty.call(target, key);
  }

  /**
   * Find element in collection.
   *
   * @param  {Array|Object} collection
   * @param  {Function|Object} matcher
   *
   * @return {Object}
   */

  function find(collection, matcher) {
    matcher = toMatcher(matcher);
    var match;
    forEach(collection, function (val, key) {
      if (matcher(val, key)) {
        match = val;
        return false;
      }
    });
    return match;
  }
  /**
   * Find element index in collection.
   *
   * @param  {Array|Object} collection
   * @param  {Function} matcher
   *
   * @return {Object}
   */

  function findIndex(collection, matcher) {
    matcher = toMatcher(matcher);
    var idx = isArray(collection) ? -1 : undefined;
    forEach(collection, function (val, key) {
      if (matcher(val, key)) {
        idx = key;
        return false;
      }
    });
    return idx;
  }
  /**
   * Find element in collection.
   *
   * @param  {Array|Object} collection
   * @param  {Function} matcher
   *
   * @return {Array} result
   */

  function filter(collection, matcher) {
    var result = [];
    forEach(collection, function (val, key) {
      if (matcher(val, key)) {
        result.push(val);
      }
    });
    return result;
  }
  /**
   * Iterate over collection; returning something
   * (non-undefined) will stop iteration.
   *
   * @param  {Array|Object} collection
   * @param  {Function} iterator
   *
   * @return {Object} return result that stopped the iteration
   */

  function forEach(collection, iterator) {
    var val, result;

    if (isUndefined(collection)) {
      return;
    }

    var convertKey = isArray(collection) ? toNum : identity;

    for (var key in collection) {
      if (has(collection, key)) {
        val = collection[key];
        result = iterator(val, convertKey(key));

        if (result === false) {
          return val;
        }
      }
    }
  }
  /**
   * Return collection without element.
   *
   * @param  {Array} arr
   * @param  {Function} matcher
   *
   * @return {Array}
   */

  function without(arr, matcher) {
    if (isUndefined(arr)) {
      return [];
    }

    ensureArray(arr);
    matcher = toMatcher(matcher);
    return arr.filter(function (el, idx) {
      return !matcher(el, idx);
    });
  }
  /**
   * Reduce collection, returning a single result.
   *
   * @param  {Object|Array} collection
   * @param  {Function} iterator
   * @param  {Any} result
   *
   * @return {Any} result returned from last iterator
   */

  function reduce(collection, iterator, result) {
    forEach(collection, function (value, idx) {
      result = iterator(result, value, idx);
    });
    return result;
  }
  /**
   * Return true if every element in the collection
   * matches the criteria.
   *
   * @param  {Object|Array} collection
   * @param  {Function} matcher
   *
   * @return {Boolean}
   */

  function every(collection, matcher) {
    return !!reduce(collection, function (matches, val, key) {
      return matches && matcher(val, key);
    }, true);
  }
  /**
   * Return true if some elements in the collection
   * match the criteria.
   *
   * @param  {Object|Array} collection
   * @param  {Function} matcher
   *
   * @return {Boolean}
   */

  function some(collection, matcher) {
    return !!find(collection, matcher);
  }
  /**
   * Transform a collection into another collection
   * by piping each member through the given fn.
   *
   * @param  {Object|Array}   collection
   * @param  {Function} fn
   *
   * @return {Array} transformed collection
   */

  function map(collection, fn) {
    var result = [];
    forEach(collection, function (val, key) {
      result.push(fn(val, key));
    });
    return result;
  }
  /**
   * Get the collections keys.
   *
   * @param  {Object|Array} collection
   *
   * @return {Array}
   */

  function keys(collection) {
    return collection && Object.keys(collection) || [];
  }
  /**
   * Shorthand for `keys(o).length`.
   *
   * @param  {Object|Array} collection
   *
   * @return {Number}
   */

  function size(collection) {
    return keys(collection).length;
  }
  /**
   * Get the values in the collection.
   *
   * @param  {Object|Array} collection
   *
   * @return {Array}
   */

  function values(collection) {
    return map(collection, function (val) {
      return val;
    });
  }
  /**
   * Group collection members by attribute.
   *
   * @param  {Object|Array} collection
   * @param  {Function} extractor
   *
   * @return {Object} map with { attrValue => [ a, b, c ] }
   */

  function groupBy(collection, extractor) {
    var grouped = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : {};
    extractor = toExtractor(extractor);
    forEach(collection, function (val) {
      var discriminator = extractor(val) || '_';
      var group = grouped[discriminator];

      if (!group) {
        group = grouped[discriminator] = [];
      }

      group.push(val);
    });
    return grouped;
  }
  function uniqueBy(extractor) {
    extractor = toExtractor(extractor);
    var grouped = {};

    for (var _len = arguments.length, collections = new Array(_len > 1 ? _len - 1 : 0), _key = 1; _key < _len; _key++) {
      collections[_key - 1] = arguments[_key];
    }

    forEach(collections, function (c) {
      return groupBy(c, extractor, grouped);
    });
    var result = map(grouped, function (val, key) {
      return val[0];
    });
    return result;
  }
  var unionBy = uniqueBy;
  /**
   * Sort collection by criteria.
   *
   * @param  {Object|Array} collection
   * @param  {String|Function} extractor
   *
   * @return {Array}
   */

  function sortBy(collection, extractor) {
    extractor = toExtractor(extractor);
    var sorted = [];
    forEach(collection, function (value, key) {
      var disc = extractor(value, key);
      var entry = {
        d: disc,
        v: value
      };

      for (var idx = 0; idx < sorted.length; idx++) {
        var d = sorted[idx].d;

        if (disc < d) {
          sorted.splice(idx, 0, entry);
          return;
        }
      } // not inserted, append (!)


      sorted.push(entry);
    });
    return map(sorted, function (e) {
      return e.v;
    });
  }
  /**
   * Create an object pattern matcher.
   *
   * @example
   *
   * const matcher = matchPattern({ id: 1 });
   *
   * let element = find(elements, matcher);
   *
   * @param  {Object} pattern
   *
   * @return {Function} matcherFn
   */

  function matchPattern(pattern) {
    return function (el) {
      return every(pattern, function (val, key) {
        return el[key] === val;
      });
    };
  }

  function toExtractor(extractor) {
    return isFunction(extractor) ? extractor : function (e) {
      return e[extractor];
    };
  }

  function toMatcher(matcher) {
    return isFunction(matcher) ? matcher : function (e) {
      return e === matcher;
    };
  }

  function identity(arg) {
    return arg;
  }

  function toNum(arg) {
    return Number(arg);
  }

  /**
   * Debounce fn, calling it only once if the given time
   * elapsed between calls.
   *
   * Lodash-style the function exposes methods to `#clear`
   * and `#flush` to control internal behavior.
   *
   * @param  {Function} fn
   * @param  {Number} timeout
   *
   * @return {Function} debounced function
   */
  function debounce(fn, timeout) {
    var timer;
    var lastArgs;
    var lastThis;
    var lastNow;

    function fire(force) {
      var now = Date.now();
      var scheduledDiff = force ? 0 : lastNow + timeout - now;

      if (scheduledDiff > 0) {
        return schedule(scheduledDiff);
      }

      fn.apply(lastThis, lastArgs);
      clear();
    }

    function schedule(timeout) {
      timer = setTimeout(fire, timeout);
    }

    function clear() {
      if (timer) {
        clearTimeout(timer);
      }

      timer = lastNow = lastArgs = lastThis = undefined;
    }

    function flush() {
      if (timer) {
        fire(true);
      }

      clear();
    }

    function callback() {
      lastNow = Date.now();

      for (var _len = arguments.length, args = new Array(_len), _key = 0; _key < _len; _key++) {
        args[_key] = arguments[_key];
      }

      lastArgs = args;
      lastThis = this; // ensure an execution is scheduled

      if (!timer) {
        schedule(timeout);
      }
    }

    callback.flush = flush;
    callback.cancel = clear;
    return callback;
  }
  /**
   * Throttle fn, calling at most once
   * in the given interval.
   *
   * @param  {Function} fn
   * @param  {Number} interval
   *
   * @return {Function} throttled function
   */

  function throttle(fn, interval) {
    var throttling = false;
    return function () {
      if (throttling) {
        return;
      }

      fn.apply(void 0, arguments);
      throttling = true;
      setTimeout(function () {
        throttling = false;
      }, interval);
    };
  }
  /**
   * Bind function against target <this>.
   *
   * @param  {Function} fn
   * @param  {Object}   target
   *
   * @return {Function} bound function
   */

  function bind(fn, target) {
    return fn.bind(target);
  }

  function _typeof(obj) {
    "@babel/helpers - typeof";

    if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") {
      _typeof = function (obj) {
        return typeof obj;
      };
    } else {
      _typeof = function (obj) {
        return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj;
      };
    }

    return _typeof(obj);
  }

  function _extends() {
    _extends = Object.assign || function (target) {
      for (var i = 1; i < arguments.length; i++) {
        var source = arguments[i];

        for (var key in source) {
          if (Object.prototype.hasOwnProperty.call(source, key)) {
            target[key] = source[key];
          }
        }
      }

      return target;
    };

    return _extends.apply(this, arguments);
  }

  /**
   * Convenience wrapper for `Object.assign`.
   *
   * @param {Object} target
   * @param {...Object} others
   *
   * @return {Object} the target
   */

  function assign(target) {
    for (var _len = arguments.length, others = new Array(_len > 1 ? _len - 1 : 0), _key = 1; _key < _len; _key++) {
      others[_key - 1] = arguments[_key];
    }

    return _extends.apply(void 0, [target].concat(others));
  }
  /**
   * Sets a nested property of a given object to the specified value.
   *
   * This mutates the object and returns it.
   *
   * @param {Object} target The target of the set operation.
   * @param {(string|number)[]} path The path to the nested value.
   * @param {any} value The value to set.
   */

  function set(target, path, value) {
    var currentTarget = target;
    forEach(path, function (key, idx) {
      if (typeof key !== 'number' && typeof key !== 'string') {
        throw new Error('illegal key type: ' + _typeof(key) + '. Key should be of type number or string.');
      }

      if (key === 'constructor') {
        throw new Error('illegal key: constructor');
      }

      if (key === '__proto__') {
        throw new Error('illegal key: __proto__');
      }

      var nextKey = path[idx + 1];
      var nextTarget = currentTarget[key];

      if (isDefined(nextKey) && isNil(nextTarget)) {
        nextTarget = currentTarget[key] = isNaN(+nextKey) ? {} : [];
      }

      if (isUndefined(nextKey)) {
        if (isUndefined(value)) {
          delete currentTarget[key];
        } else {
          currentTarget[key] = value;
        }
      } else {
        currentTarget = nextTarget;
      }
    });
    return target;
  }
  /**
   * Gets a nested property of a given object.
   *
   * @param {Object} target The target of the get operation.
   * @param {(string|number)[]} path The path to the nested value.
   * @param {any} [defaultValue] The value to return if no value exists.
   */

  function get(target, path, defaultValue) {
    var currentTarget = target;
    forEach(path, function (key) {
      // accessing nil property yields <undefined>
      if (isNil(currentTarget)) {
        currentTarget = undefined;
        return false;
      }

      currentTarget = currentTarget[key];
    });
    return isUndefined(currentTarget) ? defaultValue : currentTarget;
  }
  /**
   * Pick given properties from the target object.
   *
   * @param {Object} target
   * @param {Array} properties
   *
   * @return {Object} target
   */

  function pick(target, properties) {
    var result = {};
    var obj = Object(target);
    forEach(properties, function (prop) {
      if (prop in obj) {
        result[prop] = target[prop];
      }
    });
    return result;
  }
  /**
   * Pick all target properties, excluding the given ones.
   *
   * @param {Object} target
   * @param {Array} properties
   *
   * @return {Object} target
   */

  function omit(target, properties) {
    var result = {};
    var obj = Object(target);
    forEach(obj, function (prop, key) {
      if (properties.indexOf(key) === -1) {
        result[key] = prop;
      }
    });
    return result;
  }
  /**
   * Recursively merge `...sources` into given target.
   *
   * Does support merging objects; does not support merging arrays.
   *
   * @param {Object} target
   * @param {...Object} sources
   *
   * @return {Object} the target
   */

  function merge(target) {
    for (var _len2 = arguments.length, sources = new Array(_len2 > 1 ? _len2 - 1 : 0), _key2 = 1; _key2 < _len2; _key2++) {
      sources[_key2 - 1] = arguments[_key2];
    }

    if (!sources.length) {
      return target;
    }

    forEach(sources, function (source) {
      // skip non-obj sources, i.e. null
      if (!source || !isObject(source)) {
        return;
      }

      forEach(source, function (sourceVal, key) {
        if (key === '__proto__') {
          return;
        }

        var targetVal = target[key];

        if (isObject(sourceVal)) {
          if (!isObject(targetVal)) {
            // override target[key] with object
            targetVal = {};
          }

          target[key] = merge(targetVal, sourceVal);
        } else {
          target[key] = sourceVal;
        }
      });
    });
    return target;
  }

  var index_esm = /*#__PURE__*/Object.freeze({
    __proto__: null,
    assign: assign,
    bind: bind,
    debounce: debounce,
    ensureArray: ensureArray,
    every: every,
    filter: filter,
    find: find,
    findIndex: findIndex,
    flatten: flatten,
    forEach: forEach,
    get: get,
    groupBy: groupBy,
    has: has,
    isArray: isArray,
    isDefined: isDefined,
    isFunction: isFunction,
    isNil: isNil,
    isNumber: isNumber,
    isObject: isObject,
    isString: isString,
    isUndefined: isUndefined,
    keys: keys,
    map: map,
    matchPattern: matchPattern,
    merge: merge,
    omit: omit,
    pick: pick,
    reduce: reduce,
    set: set,
    size: size,
    some: some,
    sortBy: sortBy,
    throttle: throttle,
    unionBy: unionBy,
    uniqueBy: uniqueBy,
    values: values,
    without: without
  });

  var commonjsGlobal = typeof globalThis !== 'undefined' ? globalThis : typeof window !== 'undefined' ? window : typeof global !== 'undefined' ? global : typeof self !== 'undefined' ? self : {};

  function getAugmentedNamespace(n) {
    if (n.__esModule) return n;
    var a = Object.defineProperty({}, '__esModule', { value: true });
    Object.keys(n).forEach(function (k) {
      var d = Object.getOwnPropertyDescriptor(n, k);
      Object.defineProperty(a, k, d.get ? d : {
        enumerable: true,
        get: function () {
          return n[k];
        }
      });
    });
    return a;
  }

  function createCommonjsModule(fn) {
    var module = { exports: {} };
    return fn(module, module.exports), module.exports;
  }

  var require$$0 = /*@__PURE__*/getAugmentedNamespace(index_esm);

  const {
    isArray: isArray$1,
    isObject: isObject$1
  } = require$$0;


  class Reporter {
    constructor({ moddleRoot, rule }) {
      this.rule = rule;
      this.moddleRoot = moddleRoot;
      this.messages = [];
      this.report = this.report.bind(this);
    }

    /**
     * @param {string} id
     * @param {string} message
     * @param {string[]|Object} path
     *
     * @example
     *
     * Reporter.report('foo', 'Foo error', [ 'foo', 'bar', 'baz' ]);
     *
     * @example
     *
     * Reporter.report('foo', 'Foo error', {
     *  path: [ 'foo', 'bar', 'baz' ],
     *  foo: 'foo'
     * });
     */
    report(id, message, path) {
      let report = {
        id,
        message
      };

      if (path && isArray$1(path)) {
        report = {
          ...report,
          path
        };
      }

      if (path && isObject$1(path)) {
        report = {
          ...report,
          ...path
        };
      }

      this.messages.push(report);
    }
  }

  var testRule = function testRule({ moddleRoot, rule }) {
    const reporter = new Reporter({ rule, moddleRoot });

    const check = rule.check;

    const enter = check && check.enter || check;
    const leave = check && check.leave;

    if (!enter && !leave) {
      throw new Error('no check implemented');
    }

    traverse(moddleRoot, {
      enter: enter ? (node) => enter(node, reporter) : null,
      leave: leave ? (node) => leave(node, reporter) : null
    });

    return reporter.messages;
  };

  const categoryMap = {
    0: 'off',
    1: 'warn',
    2: 'error'
  };


  function Linter(options = {}) {

    const {
      config,
      resolver
    } = options;

    if (typeof resolver === 'undefined') {
      throw new Error('must provide <options.resolver>');
    }

    this.config = config;
    this.resolver = resolver;

    this.cachedRules = {};
    this.cachedConfigs = {};
  }


  var linter = Linter;

  /**
   * Applies a rule on the moddleRoot and adds reports to the finalReport
   *
   * @param {ModdleElement} moddleRoot
   *
   * @param {Object} ruleDefinition.name
   * @param {Object} ruleDefinition.config
   * @param {Object} ruleDefinition.category
   * @param {Rule} ruleDefinition.rule
   *
   * @return {Array<ValidationErrors>} rule reports
   */
  Linter.prototype.applyRule = function applyRule(moddleRoot, ruleDefinition) {

    const {
      config,
      rule,
      category,
      name
    } = ruleDefinition;

    try {

      const reports = testRule({
        moddleRoot,
        rule,
        config
      });

      return reports.map(function (report) {
        return {
          ...report,
          category
        };
      });
    } catch (e) {
      console.error('rule <' + name + '> failed with error: ', e);

      return [
        {
          message: 'Rule error: ' + e.message,
          category: 'error'
        }
      ];
    }

  };


  Linter.prototype.resolveRule = function (name, config) {

    const {
      pkg,
      ruleName
    } = this.parseRuleName(name);

    const id = `${pkg}-${ruleName}`;

    const rule = this.cachedRules[id];

    if (rule) {
      return Promise.resolve(rule);
    }

    return Promise.resolve(this.resolver.resolveRule(pkg, ruleName)).then((ruleFactory) => {

      if (!ruleFactory) {
        throw new Error(`unknown rule <${name}>`);
      }

      const rule = this.cachedRules[id] = ruleFactory(config);

      return rule;
    });
  };

  Linter.prototype.resolveConfig = function (name) {

    const {
      pkg,
      configName
    } = this.parseConfigName(name);

    const id = `${pkg}-${configName}`;

    const config = this.cachedConfigs[id];

    if (config) {
      return Promise.resolve(config);
    }

    return Promise.resolve(this.resolver.resolveConfig(pkg, configName)).then((config) => {

      if (!config) {
        throw new Error(`unknown config <${name}>`);
      }

      const actualConfig = this.cachedConfigs[id] = this.normalizeConfig(config, pkg);

      return actualConfig;
    });
  };

  /**
   * Take a linter config and return list of resolved rules.
   *
   * @param {Object} config
   *
   * @return {Array<RuleDefinition>}
   */
  Linter.prototype.resolveRules = function (config) {

    return this.resolveConfiguredRules(config).then((rulesConfig) => {

      // parse rule values
      const parsedRules = Object.entries(rulesConfig).map(([name, value]) => {
        const {
          category,
          config
        } = this.parseRuleValue(value);

        return {
          name,
          category,
          config
        };
      });

      // filter only for enabled rules
      const enabledRules = parsedRules.filter(definition => definition.category !== 'off');

      // load enabled rules
      const loaders = enabledRules.map((definition) => {

        const {
          name,
          config
        } = definition;

        return this.resolveRule(name, config).then(function (rule) {
          return {
            ...definition,
            rule
          };
        });
      });

      return Promise.all(loaders);
    });
  };


  Linter.prototype.resolveConfiguredRules = function (config) {

    let parents = config.extends;

    if (typeof parents === 'string') {
      parents = [parents];
    }

    if (typeof parents === 'undefined') {
      parents = [];
    }

    return Promise.all(
      parents.map((configName) => {
        return this.resolveConfig(configName).then((config) => {
          return this.resolveConfiguredRules(config);
        });
      })
    ).then((inheritedRules) => {

      const overrideRules = this.normalizeConfig(config, 'bpmnlint').rules;

      const rules = [...inheritedRules, overrideRules].reduce((rules, currentRules) => {
        return {
          ...rules,
          ...currentRules
        };
      }, {});

      return rules;
    });
  };


  /**
   * Lint the given model root, using the specified linter config.
   *
   * @param {ModdleElement} moddleRoot
   * @param {Object} [config] the bpmnlint configuration to use
   *
   * @return {Object} lint results, keyed by category names
   */
  Linter.prototype.lint = function (moddleRoot, config) {

    config = config || this.config;

    // load rules
    return this.resolveRules(config).then((ruleDefinitions) => {

      const allReports = {};

      ruleDefinitions.forEach((ruleDefinition) => {

        const {
          name
        } = ruleDefinition;

        const reports = this.applyRule(moddleRoot, ruleDefinition);

        if (reports.length) {
          allReports[name] = reports;
        }
      });

      return allReports;
    });
  };


  Linter.prototype.parseRuleValue = function (value) {

    let category;
    let config;

    if (Array.isArray(value)) {
      category = value[0];
      config = value[1];
    } else {
      category = value;
      config = {};
    }

    // normalize rule flag to <error> and <warn> which
    // may be upper case or a number at this point
    if (typeof category === 'string') {
      category = category.toLowerCase();
    }

    category = categoryMap[category] || category;

    return {
      config,
      category
    };
  };

  Linter.prototype.parseRuleName = function (name, localPackage = 'bpmnlint') {

    /**
     * We recognize the following rule name patterns:
     *
     * {RULE_NAME} => PKG = 'bpmnlint'
     * bpmnlint/{RULE_NAME} => PKG = 'bpmnlint'
     * {PACKAGE_SHORTCUT}/{RULE_NAME} => PKG = 'bpmnlint-plugin-{PACKAGE_SHORTCUT}'
     * bpmnlint-plugin-{PACKAGE_SHORTCUT}/{RULE_NAME} => PKG = 'bpmnlint-plugin-{PACKAGE_SHORTCUT}'
     * @scope/{PACKAGE_SHORTCUT}/{RULE_NAME} => PKG = '@scope/bpmnlint-plugin-{PACKAGE_SHORTCUT}'
     * @scope/bpmnlint-plugin-{PACKAGE_SHORTCUT}/{RULE_NAME} => PKG = '@scope/bpmnlint-plugin-{PACKAGE_SHORTCUT}'
     */

    const match = /^(?:(?:(@[^/]+)\/)?([^@]{1}[^/]*)\/)?([^/]+)$/.exec(name);

    if (!match) {
      throw new Error(`unparseable rule name <${name}>`);
    }

    const [
      _,
      ns,
      packageName,
      ruleName
    ] = match;

    if (!packageName) {
      return {
        pkg: localPackage,
        ruleName
      };
    }

    const pkg = `${ns ? ns + '/' : ''}${prefixPackage(packageName)}`;

    return {
      pkg,
      ruleName
    };
  };


  Linter.prototype.parseConfigName = function (name) {

    /**
     * We recognize the following config name patterns:
     *
     * bpmnlint:{CONFIG_NAME} => PKG = 'bpmnlint'
     * plugin:{PACKAGE_SHORTCUT}/{CONFIG_NAME} => PKG = 'bpmnlint-plugin-{PACKAGE_SHORTCUT}'
     * plugin:bpmnlint-plugin-{PACKAGE_SHORTCUT}/{CONFIG_NAME} => PKG = 'bpmnlint-plugin-{PACKAGE_SHORTCUT}'
     * plugin:@scope/{PACKAGE_SHORTCUT}/{CONFIG_NAME} => PKG = '@scope/bpmnlint-plugin-{PACKAGE_SHORTCUT}'
     * plugin:@scope/bpmnlint-plugin-{PACKAGE_SHORTCUT}/{CONFIG_NAME} => PKG = '@scope/bpmnlint-plugin-{PACKAGE_SHORTCUT}'
     */

    const match = /^(?:(?:plugin:(?:(@[^/]+)\/)?([^@]{1}[^/]*)\/)|bpmnlint:)([^/]+)$/.exec(name);

    if (!match) {
      throw new Error(`unparseable config name <${name}>`);
    }

    const [
      _,
      ns,
      packageName,
      configName
    ] = match;

    if (!packageName) {
      return {
        pkg: 'bpmnlint',
        configName
      };
    }

    const pkg = `${ns ? ns + '/' : ''}${prefixPackage(packageName)}`;

    return {
      pkg,
      configName
    };
  };


  Linter.prototype.getSimplePackageName = function (name) {

    /**
     * We recognize the following package name patterns:
     *
     * bpmnlint => PKG = 'bpmnlint'
     * {PACKAGE_SHORTCUT} => PKG = PACKAGE_SHORTCUT
     * bpmnlint-plugin-{PACKAGE_SHORTCUT}' => PKG = PACKAGE_SHORTCUT
     * @scope/{PACKAGE_SHORTCUT} => PKG = '@scope/{PACKAGE_SHORTCUT}'
     * @scope/bpmnlint-plugin-{PACKAGE_SHORTCUT}' => PKG = '@scope/PACKAGE_SHORTCUT'
     */

    const match = /^(?:(@[^/]+)\/)?([^/]+)$/.exec(name);

    if (!match) {
      throw new Error(`unparseable package name <${name}>`);
    }

    const [
      _,
      ns,
      packageName
    ] = match;

    return `${ns ? ns + '/' : ''}${unprefixPackage(packageName)}`;
  };


  /**
   * Validate and return validated config.
   *
   * @param  {Object} config
   * @param  {String} localPackage
   *
   * @return {Object} validated config
   */
  Linter.prototype.normalizeConfig = function (config, localPackage) {

    const rules = config.rules || {};

    const validatedRules = Object.keys(rules).reduce((normalizedRules, name) => {

      const value = rules[name];

      const {
        pkg,
        ruleName
      } = this.parseRuleName(name, localPackage);

      const normalizedName = (
        pkg === 'bpmnlint'
          ? ruleName
          : `${this.getSimplePackageName(pkg)}/${ruleName}`
      );

      normalizedRules[normalizedName] = value;

      return normalizedRules;
    }, {});

    return {
      ...config,
      rules: validatedRules
    };
  };


  // helpers ///////////////////////////

  function prefixPackage(pkg) {

    if (pkg === 'bpmnlint') {
      return 'bpmnlint';
    }

    if (pkg.startsWith('bpmnlint-plugin-')) {
      return pkg;
    }

    return `bpmnlint-plugin-${pkg}`;
  }


  function unprefixPackage(pkg) {

    if (pkg.startsWith('bpmnlint-plugin-')) {
      return pkg.substring('bpmnlint-plugin-'.length);
    }

    return pkg;
  }

  var lib = {
    Linter: linter
  };

  /**
   * Set attribute `name` to `val`, or get attr `name`.
   *
   * @param {Element} el
   * @param {String} name
   * @param {String} [val]
   * @api public
   */

  /**
   * Expose `parse`.
   */

  var domify = parse;

  /**
   * Tests for browser support.
   */

  var innerHTMLBug = false;
  var bugTestDiv;
  if (typeof document !== 'undefined') {
    bugTestDiv = document.createElement('div');
    // Setup
    bugTestDiv.innerHTML = '  <link/><table></table><a href="/a">a</a><input type="checkbox"/>';
    // Make sure that link elements get serialized correctly by innerHTML
    // This requires a wrapper element in IE
    innerHTMLBug = !bugTestDiv.getElementsByTagName('link').length;
    bugTestDiv = undefined;
  }

  /**
   * Wrap map from jquery.
   */

  var map$1 = {
    legend: [1, '<fieldset>', '</fieldset>'],
    tr: [2, '<table><tbody>', '</tbody></table>'],
    col: [2, '<table><tbody></tbody><colgroup>', '</colgroup></table>'],
    // for script/link/style tags to work in IE6-8, you have to wrap
    // in a div with a non-whitespace character in front, ha!
    _default: innerHTMLBug ? [1, 'X<div>', '</div>'] : [0, '', '']
  };

  map$1.td =
    map$1.th = [3, '<table><tbody><tr>', '</tr></tbody></table>'];

  map$1.option =
    map$1.optgroup = [1, '<select multiple="multiple">', '</select>'];

  map$1.thead =
    map$1.tbody =
    map$1.colgroup =
    map$1.caption =
    map$1.tfoot = [1, '<table>', '</table>'];

  map$1.polyline =
    map$1.ellipse =
    map$1.polygon =
    map$1.circle =
    map$1.text =
    map$1.line =
    map$1.path =
    map$1.rect =
    map$1.g = [1, '<svg xmlns="http://www.w3.org/2000/svg" version="1.1">', '</svg>'];

  /**
   * Parse `html` and return a DOM Node instance, which could be a TextNode,
   * HTML DOM Node of some kind (<div> for example), or a DocumentFragment
   * instance, depending on the contents of the `html` string.
   *
   * @param {String} html - HTML string to "domify"
   * @param {Document} doc - The `document` instance to create the Node for
   * @return {DOMNode} the TextNode, DOM Node, or DocumentFragment instance
   * @api private
   */

  function parse(html, doc) {
    if ('string' != typeof html) throw new TypeError('String expected');

    // default to the global `document` object
    if (!doc) doc = document;

    // tag name
    var m = /<([\w:]+)/.exec(html);
    if (!m) return doc.createTextNode(html);

    html = html.replace(/^\s+|\s+$/g, ''); // Remove leading/trailing whitespace

    var tag = m[1];

    // body support
    if (tag == 'body') {
      var el = doc.createElement('html');
      el.innerHTML = html;
      return el.removeChild(el.lastChild);
    }

    // wrap map
    var wrap = map$1[tag] || map$1._default;
    var depth = wrap[0];
    var prefix = wrap[1];
    var suffix = wrap[2];
    var el = doc.createElement('div');
    el.innerHTML = prefix + html + suffix;
    while (depth--) el = el.lastChild;

    // one element
    if (el.firstChild == el.lastChild) {
      return el.removeChild(el.firstChild);
    }

    // several elements
    var fragment = doc.createDocumentFragment();
    while (el.firstChild) {
      fragment.appendChild(el.removeChild(el.firstChild));
    }

    return fragment;
  }

  /*! https://mths.be/cssescape v1.5.1 by @mathias | MIT license */

  var css_escape = createCommonjsModule(function (module, exports) {
    (function (root, factory) {
      // https://github.com/umdjs/umd/blob/master/returnExports.js
      {
        // For Node.js.
        module.exports = factory(root);
      }
    }(typeof commonjsGlobal != 'undefined' ? commonjsGlobal : commonjsGlobal, function (root) {

      if (root.CSS && root.CSS.escape) {
        return root.CSS.escape;
      }

      // https://drafts.csswg.org/cssom/#serialize-an-identifier
      var cssEscape = function (value) {
        if (arguments.length == 0) {
          throw new TypeError('`CSS.escape` requires an argument.');
        }
        var string = String(value);
        var length = string.length;
        var index = -1;
        var codeUnit;
        var result = '';
        var firstCodeUnit = string.charCodeAt(0);
        while (++index < length) {
          codeUnit = string.charCodeAt(index);
          // Note: there’s no need to special-case astral symbols, surrogate
          // pairs, or lone surrogates.

          // If the character is NULL (U+0000), then the REPLACEMENT CHARACTER
          // (U+FFFD).
          if (codeUnit == 0x0000) {
            result += '\uFFFD';
            continue;
          }

          if (
            // If the character is in the range [\1-\1F] (U+0001 to U+001F) or is
            // U+007F, […]
            (codeUnit >= 0x0001 && codeUnit <= 0x001F) || codeUnit == 0x007F ||
            // If the character is the first character and is in the range [0-9]
            // (U+0030 to U+0039), […]
            (index == 0 && codeUnit >= 0x0030 && codeUnit <= 0x0039) ||
            // If the character is the second character and is in the range [0-9]
            // (U+0030 to U+0039) and the first character is a `-` (U+002D), […]
            (
              index == 1 &&
              codeUnit >= 0x0030 && codeUnit <= 0x0039 &&
              firstCodeUnit == 0x002D
            )
          ) {
            // https://drafts.csswg.org/cssom/#escape-a-character-as-code-point
            result += '\\' + codeUnit.toString(16) + ' ';
            continue;
          }

          if (
            // If the character is the first character and is a `-` (U+002D), and
            // there is no second character, […]
            index == 0 &&
            length == 1 &&
            codeUnit == 0x002D
          ) {
            result += '\\' + string.charAt(index);
            continue;
          }

          // If the character is not handled by one of the above rules and is
          // greater than or equal to U+0080, is `-` (U+002D) or `_` (U+005F), or
          // is in one of the ranges [0-9] (U+0030 to U+0039), [A-Z] (U+0041 to
          // U+005A), or [a-z] (U+0061 to U+007A), […]
          if (
            codeUnit >= 0x0080 ||
            codeUnit == 0x002D ||
            codeUnit == 0x005F ||
            codeUnit >= 0x0030 && codeUnit <= 0x0039 ||
            codeUnit >= 0x0041 && codeUnit <= 0x005A ||
            codeUnit >= 0x0061 && codeUnit <= 0x007A
          ) {
            // the character itself
            result += string.charAt(index);
            continue;
          }

          // Otherwise, the escaped character.
          // https://drafts.csswg.org/cssom/#escape-a-character
          result += '\\' + string.charAt(index);

        }
        return result;
      };

      if (!root.CSS) {
        root.CSS = {};
      }

      root.CSS.escape = cssEscape;
      return cssEscape;

    }));
  });

  var HTML_ESCAPE_MAP = {
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;',
    '"': '&quot;',
    '\'': '&#39;'
  };

  function escapeHTML(str) {
    str = '' + str;

    return str && str.replace(/[&<>"']/g, function (match) {
      return HTML_ESCAPE_MAP[match];
    });
  }

  /**
   * Is an element of the given BPMN type?
   *
   * @param  {djs.model.Base|ModdleElement} element
   * @param  {string} type
   *
   * @return {boolean}
   */
  function is(element, type) {
    var bo = getBusinessObject(element);

    return bo && (typeof bo.$instanceOf === 'function') && bo.$instanceOf(type);
  }

  /**
   * Return the business object for a given element.
   *
   * @param  {djs.model.Base|ModdleElement} element
   *
   * @return {ModdleElement}
   */
  function getBusinessObject(element) {
    return (element && element.businessObject) || element;
  }

  var ErrorSvg = "<svg width=\"12\" height=\"12\" xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 352 512\"><path fill=\"currentColor\" d=\"M242.72 256l100.07-100.07c12.28-12.28 12.28-32.19 0-44.48l-22.24-22.24c-12.28-12.28-32.19-12.28-44.48 0L176 189.28 75.93 89.21c-12.28-12.28-32.19-12.28-44.48 0L9.21 111.45c-12.28 12.28-12.28 32.19 0 44.48L109.28 256 9.21 356.07c-12.28 12.28-12.28 32.19 0 44.48l22.24 22.24c12.28 12.28 32.2 12.28 44.48 0L176 322.72l100.07 100.07c12.28 12.28 32.2 12.28 44.48 0l22.24-22.24c12.28-12.28 12.28-32.19 0-44.48L242.72 256z\"></path></svg>";

  var WarningSvg = "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"12\" height=\"12\" viewBox=\"0 0 512 512\"><path fill=\"currentColor\" d=\"M288 328.83c-45.518 0-82.419 34.576-82.419 77.229 0 42.652 36.9 77.229 82.419 77.229 45.518 0 82.419-34.577 82.419-77.23 0-42.652-36.9-77.229-82.419-77.229zM207.439 57.034l11.61 204.348c.544 9.334 8.78 16.64 18.755 16.64h100.392c9.975 0 18.211-7.306 18.754-16.64l11.611-204.348c.587-10.082-7.98-18.56-18.754-18.56H226.192c-10.775 0-19.34 8.478-18.753 18.56z\"/></svg>";

  var SuccessSvg = "<svg width=\"12\" height=\"12\" xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 512 512\"><path fill=\"currentColor\" d=\"M173.898 439.404l-166.4-166.4c-9.997-9.997-9.997-26.206 0-36.204l36.203-36.204c9.997-9.998 26.207-9.998 36.204 0L192 312.69 432.095 72.596c9.997-9.997 26.207-9.997 36.204 0l36.203 36.204c9.997 9.997 9.997 26.206 0 36.204l-294.4 294.401c-9.998 9.997-26.207 9.997-36.204-.001z\"></path></svg>";

  var OFFSET_TOP = -7,
    OFFSET_RIGHT = -7;

  var LOW_PRIORITY = 500;

  var emptyConfig = {
    resolver: {
      resolveRule: function () {
        return null;
      }
    },
    config: {}
  };

  var stateToIcon = {
    error: ErrorSvg,
    warning: WarningSvg,
    success: SuccessSvg,
    inactive: SuccessSvg
  };

  function Linting(
    bpmnjs,
    canvas,
    config,
    elementRegistry,
    eventBus,
    overlays,
    translate
  ) {
    this._bpmnjs = bpmnjs;
    this._canvas = canvas;
    this._elementRegistry = elementRegistry;
    this._eventBus = eventBus;
    this._overlays = overlays;
    this._translate = translate;

    this._issues = {};

    this._active = config && config.active || false;
    this._linterConfig = emptyConfig;

    this._overlayIds = {};

    var self = this;

    eventBus.on([
      'import.done',
      'elements.changed',
      'linting.configChanged',
      'linting.toggle'
    ], LOW_PRIORITY, function (e) {
      if (self.isActive()) {
        self.update();
      }
    });

    eventBus.on('linting.toggle', function (event) {

      const active = event.active;

      if (!active) {
        self._clearIssues();
        self._updateButton();
      }
    });

    eventBus.on('diagram.clear', function () {
      self._clearIssues();
    });

    var linterConfig = config && config.bpmnlint;

    linterConfig && eventBus.once('diagram.init', function () {

      // bail out if config was already provided
      // during initialization of other modules
      if (self.getLinterConfig() !== emptyConfig) {
        return;
      }

      try {
        self.setLinterConfig(linterConfig);
      } catch (err) {
        console.error(
          '[bpmn-js-bpmnlint] Invalid lint rules configured. ' +
          'Please doublecheck your linting.bpmnlint configuration, ' +
          'cf. https://github.com/bpmn-io/bpmn-js-bpmnlint#configure-lint-rules'
        );
      }
    });

    this._init();
  }

  Linting.prototype.setLinterConfig = function (linterConfig) {

    if (!linterConfig.config || !linterConfig.resolver) {
      throw new Error('Expected linterConfig = { config, resolver }');
    }

    this._linterConfig = linterConfig;

    this._eventBus.fire('linting.configChanged');
  };

  Linting.prototype.getLinterConfig = function () {
    return this._linterConfig;
  };

  Linting.prototype._init = function () {
    this._createButton();

    this._updateButton();
  };

  Linting.prototype.isActive = function () {
    return this._active;
  };

  Linting.prototype._formatIssues = function (issues) {

    let self = this;

    // (1) reduce issues to flat list of issues including the affected element
    let reports = reduce(issues, function (reports, ruleReports, rule) {

      return reports.concat(ruleReports.map(function (report) {
        report.rule = rule;

        return report;
      }));

    }, []);

    // (2) if affected element is not visible, then report it on root or participant level
    const participants = self._elementRegistry.filter((ele) => { return is(ele, 'bpmn:Participant'); }),
      participantBos = participants.map((ele) => { return ele.businessObject; });

    reports = map(reports, function (report) {
      const element = self._elementRegistry.get(report.id);

      if (!element) {
        report.isChildIssue = true;
        report.actualElementId = report.id;

        // (2.1) Is a participant referring to the current issue? Then display on participant
        const referringParticipant = participantBos.filter((ele) => {
          return (ele.processRef && ele.processRef.id && ele.processRef.id === report.id);
        });

        if (referringParticipant.length) {
          report.id = referringParticipant[0].id;
        } else {

          // (2.2) If there is no partcipant to display it on, display it to root
          report.id = self._canvas.getRootElement().id;
        }

      }

      return report;
    });

    // (3) group issues per elementId (resulting in ie. [elementId1: [{issue1}, {issue2}]] structure)
    reports = groupBy(reports, function (report) {
      return report.id;
    });

    return reports;

  };

  /**
   * Toggle linting on or off.
   *
   * @param {boolean} [newActive]
   *
   * @return {boolean} the new active state
   */
  Linting.prototype.toggle = function (newActive) {

    newActive = typeof newActive === 'undefined' ? !this.isActive() : newActive;

    this._setActive(newActive);

    return newActive;
  };

  Linting.prototype._setActive = function (active) {

    if (this._active === active) {
      return;
    }

    this._active = active;

    this._eventBus.fire('linting.toggle', { active: active });
  };

  /**
   * Update overlays. Always lint and check wether overlays need update or not.
   */
  Linting.prototype.update = function () {
    var self = this;

    var definitions = this._bpmnjs.getDefinitions();

    if (!definitions) {
      return;
    }

    var lintStart = this._lintStart = Math.random();

    this.lint().then(function (newIssues) {

      if (self._lintStart !== lintStart) {
        return;
      }

      newIssues = self._formatIssues(newIssues);

      var remove = {},
        update = {},
        add = {};

      for (var id1 in self._issues) {
        if (!newIssues[id1]) {
          remove[id1] = self._issues[id1];
        }
      }

      for (var id2 in newIssues) {
        if (!self._issues[id2]) {
          add[id2] = newIssues[id2];
        } else {
          if (newIssues[id2] !== self._issues[id2]) {
            update[id2] = newIssues[id2];
          }
        }
      }

      remove = assign(remove, update);
      add = assign(add, update);

      self._clearOverlays();
      self._createIssues(add);

      self._issues = newIssues;

      self._updateButton();

      self._fireComplete(newIssues);
    });
  };

  Linting.prototype._fireComplete = function (issues) {
    this._eventBus.fire('linting.completed', { issues: issues });
  };

  Linting.prototype._createIssues = function (issues) {
    for (var id in issues) {
      this._createElementIssues(id, issues[id]);
    }
  };

  /**
   * Create overlay including all issues which are given for a single element.
   *
   * @param {string} elementId - id of element, for which the issue shall be displayed.
   * @param {Array} elementIssues - All element issues including warnings and errors.
   */
  Linting.prototype._createElementIssues = function (elementId, elementIssues) {
    var element = this._elementRegistry.get(elementId);

    if (!element) {
      return;
    }

    // Also attach element to subprocess plane
    var plane = this._elementRegistry.get(elementId + '_plane');
    if (plane) {
      this._createElementIssues(plane.id, elementIssues);
    }

    var menuPosition;
    var position;

    var isRoot = !element.parent;
    if (isRoot && is(element, 'bpmn:Process')) {
      menuPosition = 'bottom-right';

      position = {
        top: 20,
        left: 150
      };
    } else if (isRoot && is(element, 'bpmn:SubProcess')) {
      menuPosition = 'bottom-right';

      position = {
        top: 50,
        left: 150
      };
    } else {
      menuPosition = 'top-right';

      position = {
        top: OFFSET_TOP,
        left: OFFSET_RIGHT
      };
    }

    var issuesByType = groupBy(elementIssues, function (elementIssue) {
      return (elementIssue.isChildIssue ? 'child' : '') + elementIssue.category;
    });

    var errors = issuesByType.error,
      warnings = issuesByType.warn,
      childErrors = issuesByType.childerror,
      childWarnings = issuesByType.childwarn;

    if (!errors && !warnings && !childErrors && !childWarnings) {
      return;
    }

    var $html = domify(
      '<div class="bjsl-overlay bjsl-issues-' + menuPosition + '"></div>'
    );

    var $icon = (errors || childErrors)
      ? domify('<div class="bjsl-icon bjsl-icon-error">' + ErrorSvg + '</div>')
      : domify('<div class="bjsl-icon bjsl-icon-warning">' + WarningSvg + '</div>');

    var $dropdown = domify('<div class="bjsl-dropdown"></div>');
    var $dropdownContent = domify('<div class="bjsl-dropdown-content"></div>');

    var $issueContainer = domify('<div class="bjsl-issues"></div>');

    var $issues = domify('<div class="bjsl-current-element-issues"></div>');
    var $issueList = domify('<ul></ul>');

    $html.appendChild($icon);
    $html.appendChild($dropdown);

    $dropdown.appendChild($dropdownContent);
    $dropdownContent.appendChild($issueContainer);

    $issueContainer.appendChild($issues);

    $issues.appendChild($issueList);

    // Add errors and warnings to issueList
    if (errors) {
      this._addErrors($issueList, errors);
    }

    if (warnings) {
      this._addWarnings($issueList, warnings);
    }

    // If errors or warnings for child elements of the current element are to be displayed,
    // then add an additional list
    if (childErrors || childWarnings) {
      var $childIssues = domify('<div class="bjsl-child-issues"></div>');
      var $childIssueList = domify('<ul></ul>');
      var $childIssueLabel = domify('<a class="bjsl-issue-heading">Issues for child elements:</a>');

      if (childErrors) {
        this._addErrors($childIssueList, childErrors);
      }

      if (childWarnings) {
        this._addWarnings($childIssueList, childWarnings);
      }

      if (errors || warnings) {
        var $childIssuesSeperator = domify('<hr/>');
        $childIssues.appendChild($childIssuesSeperator);
      }

      $childIssues.appendChild($childIssueLabel);
      $childIssues.appendChild($childIssueList);
      $issueContainer.appendChild($childIssues);
    }

    this._overlayIds[elementId] = this._overlays.add(element, 'linting', {
      position: position,
      html: $html,
      scale: {
        min: .9
      }
    });
  };

  Linting.prototype._addErrors = function ($ul, errors) {

    var self = this;

    errors.forEach(function (error) {
      self._addEntry($ul, 'error', error);
    });
  };

  Linting.prototype._addWarnings = function ($ul, warnings) {

    var self = this;

    warnings.forEach(function (error) {
      self._addEntry($ul, 'warning', error);
    });
  };

  Linting.prototype._addEntry = function ($ul, state, entry) {

    var rule = entry.rule,
      message = this._translate(entry.message),
      actualElementId = entry.actualElementId;

    var icon = stateToIcon[state];

    var $entry = domify(
      '<li class="' + state + '">' +
      '<span class="icon"> ' + icon + '</span>' +
      '<a title="' + escapeHTML(rule) + ': ' + escapeHTML(message) + '" ' +
      'data-rule="' + escapeHTML(rule) + '" ' +
      'data-message="' + escapeHTML(message) + '"' +
      '>' +
      escapeHTML(message) +
      '</a>' +
      (actualElementId
        ? '<a class="bjsl-id-hint"><code>' + actualElementId + '</code></a>'
        : '') +
      '</li>'
    );

    $ul.appendChild($entry);
  };

  Linting.prototype._clearOverlays = function () {
    this._overlays.remove({ type: 'linting' });

    this._overlayIds = {};
  };

  Linting.prototype._clearIssues = function () {
    this._issues = {};

    this._clearOverlays();
  };

  Linting.prototype._setButtonState = function (state, errors, warnings) {
    var button = this._button;

    var icon = stateToIcon[state];

    var html = icon + '<span>' + this._translate('{errors} Errors, {warnings} Warnings', { errors: errors.toString(), warnings: warnings.toString() }) + '</span>';

    [
      'error',
      'inactive',
      'success',
      'warning'
    ].forEach(function (s) {
      if (state === s) {
        button.classList.add('bjsl-button-' + s);
      } else {
        button.classList.remove('bjsl-button-' + s);
      }
    });

    button.innerHTML = html;
  };

  Linting.prototype._updateButton = function () {

    if (!this.isActive()) {
      this._setButtonState('inactive', 0, 0);

      return;
    }

    var errors = 0,
      warnings = 0;

    for (var id in this._issues) {
      this._issues[id].forEach(function (issue) {
        if (issue.category === 'error') {
          errors++;
        } else if (issue.category === 'warn') {
          warnings++;
        }
      });
    }

    var state = (errors && 'error') || (warnings && 'warning') || 'success';

    this._setButtonState(state, errors, warnings);
  };

  Linting.prototype._createButton = function () {

    var self = this;

    this._button = domify(
      '<button class="bjsl-button bjsl-button-inactive" title="' + this._translate('Toggle linting') + '"></button>'
    );

    this._button.addEventListener('click', function () {
      self.toggle();
    });

    this._canvas.getContainer().appendChild(this._button);
  };

  Linting.prototype.lint = function () {
    var definitions = this._bpmnjs.getDefinitions();

    var linter = new lib.Linter(this._linterConfig);
    return linter.lint(definitions);
  };

  Linting.$inject = [
    'bpmnjs',
    'canvas',
    'config.linting',
    'elementRegistry',
    'eventBus',
    'overlays',
    'translate'
  ];

  var index = {
    __init__: ['linting', 'lintingEditorActions'],
    linting: ['type', Linting],
    lintingEditorActions: ['type', EditorActions]
  };

  return index;

})));
