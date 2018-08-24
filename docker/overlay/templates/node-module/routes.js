/*
 * Copyright (C) 2018 by Christian Jean.
 * All rights reserved.
 *
 * CONFIDENTIAL AND PROPRIETARY INFORMATION!
 *
 * Disclosure or use in part or in whole without prior written consent
 * constitutes an infringement of copyright laws which may be punishable
 * by law.
 *
 * THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESSED OR IMPLIED WARRANTIES
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL
 * THE LICENSOR OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT 
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

const PATH = '/i18n';
const BUNDLE  = PATH + '/bundle';


// ----------------------------------------------------
// Examples:
// ----------------------------------------------------
// GET /api/v1/i18n/synopsis/menu/en
// GET /api/v1/i18n/synopsis/menu/en/ca
// GET /api/v1/i18n/synopsis/menu/en/us/red-neck


const DB = { 
  applications: [
    { id: 1, name: "synopsis" },
    { id: 2, name: "i18n" },
    { id: 3, name: "foo" },
    { id: 4, name: "bar" }
  ],  
  bundles: [
    { id: 1, appid: 0, name: "system" },   // for all apps
    { id: 2, appid: 1, name: "menu" },
    { id: 3, appid: 2, name: "toolbar" },
    { id: 4, appid: 2, name: "portal" }
  ],  
  countries: [
    { id: 1, iso2: 'us', un3: 'usa', name: 'United States' },
    { id: 2, iso2: 'ca', un3: 'can', name: 'Canada' },
    { id: 3, iso2: 'fr', un3: 'fra', name: 'France' },
    { id: 4, iso2: 'sp', un3: 'spn', name: 'Spain' },
    { id: 5, iso2: 'ch', un3: 'chi', name: 'China' }
  ],  
  languages: [
    { id: 1, iso2: 'en', iso3: 'eng', name: 'English' },
    { id: 2, iso2: 'fr', iso3: 'xxx', name: 'French' },
    { id: 3, iso2: 'it', iso3: 'xxx', name: 'Italian' },
    { id: 4, iso2: 'sp', iso3: 'xxx', name: 'Spanish' },
    { id: 5, iso2: 'dt', iso3: 'xxx', name: 'Dutch' }
  ],  
  varients: [
    { id: 1, name: 'rn', desc: "Redneck" },
    { id: 2, name: 'qc', desc: "Quebecois" }
  ],  
  locales: [
    { id: 1, a: 1, b: 2, c: 3, l: 5, v: null, key: 'one', value: "One" }
  ],
  context: [
    { id: 1, localeid: 1, comment: "Some textualized context provided for locale" }
  ],
  users: [
    { id: 123, name: 'Christian Jean', perms: '' },
    { id: 345, name: 'Maria Fiorilo', perms: '' },
    { id: 678, name: 'Some User', perms: '' }
  ],
  audit: [
    { id: 1, localeid: 1, date: 30129384756, userid: 123, change: '', comment: 'Some short comment' },
    { id: 1, localeid: 1, date: 30129384756, userid: 345, change: '', comment: 'Had a typo, fixed it' },
    { id: 1, localeid: 1, date: 30129384756, userid: 123, change: '', comment: 'Some short comment' },
    { id: 1, localeid: 1, date: 30129384756, userid: 678, change: '', comment: 'Some short comment' }
  ]
};


var routes = function(app) {

  //--------------------------------------------------------------------------------
  // System API's...
  //--------------------------------------------------------------------------------

  /**
   * Provides all the applications.
   */
  app.get(BUNDLE + '/applications', function (req, res, next) {
    console.log("Providing application list...");
    let data = JSON.stringify({ success: true, data: DB.applications });
    res.json(data);
  });


  /**
   * Provides all the bundles for the application and all the system bundles (id = 0).
   */
  app.get(BUNDLE + '/:application/bundles', function (req, res, next) {
    let app = req.params.application;
    console.log("Providing bundle list for '" + app + "' application...");
    let data = JSON.stringify({ success: true, data: DB.bundles });
    res.json(data);
  });


  /**
   * Provides all the defined locales for the given application bundle.
   */
  app.get(BUNDLE + '/:application/:bundle/locales', function (req, res, next) {
    let id = req.params.id;
  });


  //--------------------------------------------------------------------------------
  // Bundle Files...
  //--------------------------------------------------------------------------------

  /**
   * @application An arbitrary value used to indicate an application.
   * @bundle An arbitrary value used to indicate a locale bundle
   */
  app.get(BUNDLE + '/:application/:bundle', function (req, res, next) {
    let id = req.params.id;
  });


  /**
   * @language An ISO 639 alpha-2 or alpha-3 language code.
   */
  app.get(BUNDLE + '/:application/:bundle/:language', function (req, res, next) {
    let id = req.params.id;
  });


  /**
   * @application An arbitrary value used to indicate an application.
   * @language An ISO 639 alpha-2 or alpha-3 language code.
   * @country  An ISO 3166 alpha-2 country code or a UN M.49 numeric-3 area code.
   */
  app.get(BUNDLE + '/:application/:bundle/:language/:country', function (req, res, next) {
    let id = req.params.id;
  });


  /**
   * @application An arbitrary value used to indicate an application.
   * @language An ISO 639 alpha-2 or alpha-3 language code.
   * @country  An ISO 3166 alpha-2 country code or a UN M.49 numeric-3 area code.
   * @variant  Any arbitrary value used to indicate a variation of a Locale.
   */
  app.get(BUNDLE + '/:application/:bundle/:language/:country/:variant', function (req, res, next) {
    let id = req.params.id;
  });
};

module.exports = routes;
