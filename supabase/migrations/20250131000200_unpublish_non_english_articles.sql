-- Task 17 content-quality audit: 3 legacy articles are written entirely in
-- non-English languages (Portuguese, Spanish, German) on an otherwise
-- English-only site. Per the site owner's decision, archive rather than
-- delete: this removes them from all public listings/detail pages (every
-- articles repository query filters on status='published') while keeping
-- the rows, their media, and their category/location links intact for a
-- future translation pass if one is ever done.
update nodes
  set status = 'archived'
  where node_type = 'article'
    and slug in (
      'ilhas-maldivas-para-visitantes', -- Portuguese: "Ilhas Maldivas para visitantes"
      'las-islas-maldivas',             -- Spanish: "Las Islas Maldivas"
      'malediven-urlaub'                -- German: "Malediven Urlaub"
    );
